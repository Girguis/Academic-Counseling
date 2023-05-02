using ClosedXML.Excel;
using FOS.App.ExcelReader;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
    public class ProgramController : Controller
    {
        private readonly ILogger<ProgramController> logger;
        private readonly IProgramRepo programRepo;
        private readonly ICourseRepo courseRepo;
        private readonly IAcademicYearRepo academicYearRepo;

        public ProgramController(ILogger<ProgramController> logger,
            IProgramRepo programRepo,
            ICourseRepo courseRepo,
            IAcademicYearRepo academicYearRepo)
        {
            this.logger = logger;
            this.programRepo = programRepo;
            this.courseRepo = courseRepo;
            this.academicYearRepo = academicYearRepo;
        }
        [HttpGet("GetProgramAddTemplate")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult GetProgramAddTemplate()
        {
            try
            {
                var stream = ProgramSheet.Create(programRepo.GetAllProgramsNames(), courseRepo.GetAll(), academicYearRepo.GetAcademicYearsList());
                return File(stream,
                            "application/vnd.ms-excel",
                            "ProgramTemplate.xlsx");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("Add")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult Add([FromBody] ProgramModel model)
        {
            try
            {
                var res = programRepo.AddProgram(model);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = model
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("AddNewProgramViaExcel")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult AddNewProgramViaExcel(IFormFile file)
        {
            try
            {
                if (file == null || file.Length < 1 || !file.FileName.EndsWith(".xlsx"))
                    return BadRequest(new { Massage = Resource.FileNotValid });
                MemoryStream ms = new();
                file.OpenReadStream().CopyTo(ms);
                var wb = new XLWorkbook(ms);
                ms.Close();
                var model = ProgramSheet.Read(wb, programRepo.GetPrograms(), courseRepo.GetAll(), academicYearRepo.GetAcademicYearsList());
                if (model == null)
                    return BadRequest(new { Massage = Resource.InvalidData });
                var res = programRepo.AddProgram(model);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = model
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetProgramExcel/{id}")]
        public IActionResult GetProgramExcel(string id)
        {
            try
            {
                var program = programRepo.GetProgramDetails(id);
                if (program.BasicData == null)
                    return NotFound();
                var stream = ProgramSheet.Create(program, programRepo.GetAllProgramsNames(), courseRepo.GetAll(), academicYearRepo.GetAcademicYearsList());
                return File(stream,
                         "application/vnd.ms-excel",
                         program.BasicData.Name + "_Data.xlsx");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("UpdateProgramViaExcel/{programID}")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult UpdateProgramViaExcel(string programID, IFormFile file)
        {
            try
            {
                var program = programRepo.GetProgram(programID);
                if (program == null) return NotFound();
                if (file == null || file.Length < 1 || !file.FileName.EndsWith(".xlsx"))
                    return BadRequest(new { Massage = Resource.FileNotValid });
                MemoryStream ms = new();
                file.OpenReadStream().CopyTo(ms);
                var wb = new XLWorkbook(ms);
                ms.Close();
                var model = ProgramSheet.Read(wb, programRepo.GetPrograms(), courseRepo.GetAll(), academicYearRepo.GetAcademicYearsList());
                if (model == null)
                    return BadRequest(new { Massage = Resource.InvalidData });
                bool updated = programRepo.UpdateProgram(program.Id, model);
                if (!updated) return BadRequest(new { Massage = Resource.ErrorOccurred });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpGet("Get/{id}")]
        public IActionResult Get(string id)
        {
            try
            {
                var program = programRepo.GetProgram(id);
                if (program == null)
                    return NotFound();
                return Ok(program);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("GetAll")]
        public IActionResult GetAll([FromBody] SearchCriteria criteria)
        {
            try
            {
                var res = programRepo.GetPrograms(out int totalCount, criteria);
                return Ok(new
                {
                    TotalCount = totalCount,
                    Data = res
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("UpdateBasicData")]
        public IActionResult UpdateBasicData(ProgramBasicDataUpdateParamModel model)
        {
            try
            {
                var updated = programRepo.UpdateProgramBasicData(model);
                if (!updated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = model
                    });
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
