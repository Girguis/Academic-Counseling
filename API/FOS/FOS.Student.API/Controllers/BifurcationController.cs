using FOS.App.Student.DTOs;
using FOS.App.Student.Mappers;
using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using FOS.Student.API.Mapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Controllers
{
    public class BifurcationController : ExtensionController
    {
        private readonly IBifurcationRepo bifurcationRepo;
        private readonly IStudentRepo studentRepo;
        private readonly IProgramRepo programRepo;

        public BifurcationController(
            IBifurcationRepo bifurcationRepo,
            IStudentRepo studentRepo,
            IProgramRepo programRepo
            )
        {
            this.bifurcationRepo = bifurcationRepo;
            this.studentRepo = studentRepo;
            this.programRepo = programRepo;
        }

        [Authorize]
        [HttpGet]
        [ProducesResponseType(200,Type =typeof(List<DesireProgramsDTO>))]
        public IActionResult GetDesires()
        {
            string? guid = GetGuid();
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
        [Authorize]
        [HttpPost]
        public IActionResult AddDesires(List<DesireProgramsDTO> desiresList)
        {
            string? guid = GetGuid();
            if (string.IsNullOrWhiteSpace(guid))
                return BadRequest(new { msg = "Id not found" });
            if (desiresList.Count < 1 || desiresList == null)
                return BadRequest(new { msg = "List is empty" });
            if (!bifurcationRepo.IsBifurcationAvailable())
                return BadRequest(new { msg = "Bifuraction is not availble now" });

            DB.Models.Student student = studentRepo.Get(guid);
            if (student == null) return BadRequest(new { msg = "Student not found" });

            List<StudentDesire> mappedDesires = student.ToModel(desiresList);
            if (!bifurcationRepo.AddDesires(mappedDesires))
                return BadRequest(new { msg = "Error occured while adding desires" });
            return Ok();
        }
    }
}
