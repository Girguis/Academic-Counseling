using FOS.Core.Languages;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Students.API.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Students.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class BifurcationController : ControllerBase
    {
        private readonly IBifurcationRepo bifurcationRepo;
        private readonly IStudentRepo studentRepo;
        private readonly ILogger<BifurcationController> logger;
        private readonly IDateRepo dateRepo;

        public BifurcationController(
            IBifurcationRepo bifurcationRepo,
            IStudentRepo studentRepo,
            ILogger<BifurcationController> logger,
            IDateRepo dateRepo
            )
        {
            this.bifurcationRepo = bifurcationRepo;
            this.studentRepo = studentRepo;
            this.logger = logger;
            this.dateRepo = dateRepo;
        }

        /// <summary>
        /// Get student by GUID and check if he/she's not in a Special program and current datetime is in bifurcation peroid
        /// if all reqirements are met, then get a list of programs the student can order, or get his/her stored list from the DB if exists
        /// </summary>
        /// <returns>list of programs</returns>
        [HttpGet]
        [ProducesResponseType(200, Type = typeof(Response))]
        public IActionResult GetDesires()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = Resource.InvalidID
                    });
                if (!dateRepo.IsInRegisrationInterval((int)DateForEnum.Bifurcation))
                    return Ok(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = string.Format(Resource.NotAvailable, Resource.Bifuraction)
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (student.IsInSpecialProgram.Value)
                    return Ok(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = Resource.NoMoreBifuraction
                    });
                var desires = bifurcationRepo.GetDesires(student.Id);
                return Ok(new Response
                {
                    isBifurcationAvailable = true,
                    Data = desires,
                    Massage = ""
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        /// <summary>
        /// Get GUID from access token
        /// do some checks on the received list and that the bifurcation is available
        /// if everyting is ok then map desiresList with student id to StudentDesire model
        /// </summary>
        /// <param name="desiresList"></param>
        /// <returns></returns>
        [HttpPost]
        public IActionResult AddDesires(List<byte> desiresList)
        {
            try
            {
                string guid = this.Guid();
                //Some validations when receiving request
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = Resource.InvalidID
                    });
                if (desiresList.Count < 1 || desiresList == null)
                    return Ok(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = Resource.EmptyList
                    });
                if (!dateRepo.IsInRegisrationInterval((int)DateForEnum.Bifurcation))
                    return Ok(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = string.Format(Resource.NotAvailable, Resource.Bifuraction)
                    });
                //Get student record from DB
                DB.Models.Student student = studentRepo.Get(guid);
                if (student.IsInSpecialProgram.HasValue && student.IsInSpecialProgram.Value)
                    return Ok(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = Resource.NoMoreBifuraction
                    });

                if (student == null) return BadRequest(new Response
                {
                    isBifurcationAvailable = true,
                    Data = null,
                    Massage = string.Format(Resource.DoesntExist, Resource.Student)
                });
                //checks if error occured while add/updating student desires
                if (!bifurcationRepo.AddDesires(student.CurrentProgramId, student.Id, desiresList))
                    return Ok(new Response
                    {
                        isBifurcationAvailable = true,
                        Data = desiresList,
                        Massage = Resource.ErrorOccured
                    });
                return Ok(new Response
                {
                    isBifurcationAvailable = true,
                    Massage = "Done"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
    class Response
    {
        public bool isBifurcationAvailable { get; set; }
        public string Massage { get; set; }
        public Object Data { get; set; }
    }
}
