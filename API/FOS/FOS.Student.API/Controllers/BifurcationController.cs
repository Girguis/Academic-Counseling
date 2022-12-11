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
        [HttpGet]
        [ProducesResponseType(200, Type = typeof(List<DesireProgramsDTO>))]
        //Returns a list of programs that student can choose from
        public IActionResult GetDesires()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new { msg = "Id not found" });
                //Check if the bifurcation avaiable and that the student is not in final program
                if (!bifurcationRepo.IsBifurcationAvailable() || studentRepo.Get(guid).IsInSpecialProgram)
                    return BadRequest(new { msg = "Bifuraction is not availble" });
                //Get the list of student desires from DB
                var desires = bifurcationRepo.GetDesires(guid);
                List<DesireProgramsDTO> desiresLst;
                //if the student doesn't have any records in DB then returns the list of available programs
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
