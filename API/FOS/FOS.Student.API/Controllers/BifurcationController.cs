using FOS.App.Student.DTOs;
using FOS.App.Student.Mappers;
using FOS.Core.IRepositories;
using FOS.Student.API.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Controllers
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
                        Massage = "ID not found"
                    });
                if (!dateRepo.IsInRegisrationInterval(0))
                    return BadRequest(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = "Bifuraction is not available"
                    });
                if (studentRepo.Get(guid).IsInSpecialProgram)
                    return BadRequest(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = "There's no more bifuraction for you"
                    });
                var desires = bifurcationRepo.GetDesires(guid);
                List<DesireProgramsDTO> desiresLst;
                if (desires == null || desires.Count < 1)
                    desiresLst = bifurcationRepo.GetAvailableProgram(guid).ToDTO();
                else
                    desiresLst = desires.ToDTO();
                return Ok(new Response
                {
                    isBifurcationAvailable = true,
                    Data = desiresLst,
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
                        Massage = "ID not found"
                    });
                if (desiresList.Count < 1 || desiresList == null)
                    return BadRequest(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = "Desires list are empty"
                    });
                if (!dateRepo.IsInRegisrationInterval(0))
                    return BadRequest(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = "Bifuraction is not availble"
                    });
                if (studentRepo.Get(guid).IsInSpecialProgram)
                    return BadRequest(new Response
                    {
                        isBifurcationAvailable = false,
                        Data = null,
                        Massage = "There's no more bifuraction for you"
                    });
                //Get student record from DB
                DB.Models.Student student = studentRepo.Get(guid);
                if (student == null) return BadRequest(new Response
                {
                    isBifurcationAvailable = true,
                    Data = null,
                    Massage = "Student not found"
                });
                //checks if error occured while add/updating student desires
                if (!bifurcationRepo.AddDesires(student.Id, desiresList))
                    return BadRequest(new Response
                    {
                        isBifurcationAvailable = true,
                        Data = desiresList,
                        Massage = "Error occured while adding desires"
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
