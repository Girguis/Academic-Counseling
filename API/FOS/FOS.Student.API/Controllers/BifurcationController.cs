using FOS.App.Student.DTOs;
using FOS.App.Student.Mappers;
using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using FOS.Student.API.Extensions;
using FOS.Student.API.Mapper;
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

        public BifurcationController(
            IBifurcationRepo bifurcationRepo,
            IStudentRepo studentRepo,
            ILogger<BifurcationController> logger
            )
        {
            this.bifurcationRepo = bifurcationRepo;
            this.studentRepo = studentRepo;
            this.logger = logger;
        }

        /// <summary>
        /// Get student by GUID and check if he/she's not in a Special program and current datetime is in bifurcation peroid
        /// if all reqirements are met, then get a list of programs the student can order, or get his/her stored list from the DB if exists
        /// </summary>
        /// <returns>list of programs</returns>
        [HttpGet]
        [ProducesResponseType(200, Type = typeof(List<DesireProgramsDTO>))]
        public IActionResult GetDesires()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new { msg = "Id not found" });
                if (!bifurcationRepo.IsBifurcationAvailable() || studentRepo.Get(guid).IsInSpecialProgram)
                    return BadRequest(new { msg = "Bifuraction is not availble" });
                var desires = bifurcationRepo.GetDesires(guid);
                List<DesireProgramsDTO> desiresLst;
                if (desires == null || desires.Count < 1)
                    desiresLst = bifurcationRepo.GetAvailableProgram(guid).ToDTO();
                else
                    desiresLst = desires.ToDTO();
                return Ok(desiresLst);
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
        public IActionResult AddDesires(List<DesireProgramsDTO> desiresList)
        {
            try
            {
                string guid = this.Guid();
                //Some validations when receiving request
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new { msg = "Id not found" });
                if (desiresList.Count < 1 || desiresList == null)
                    return BadRequest(new { msg = "List is empty" });
                if (!bifurcationRepo.IsBifurcationAvailable() || studentRepo.Get(guid).IsInSpecialProgram)
                    return BadRequest(new { msg = "Bifuraction is not availble now" });
                //Get student record from DB
                DB.Models.Student student = studentRepo.Get(guid);
                if (student == null) return BadRequest(new { msg = "Student not found" });
                //Mapping student desires so it can be added in the DB
                List<StudentDesire> mappedDesires = student.ToModel(desiresList);
                //checks if error occured while add/updating student desires
                if (!bifurcationRepo.AddDesires(mappedDesires))
                    return BadRequest(new { msg = "Error occured while adding desires" });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
