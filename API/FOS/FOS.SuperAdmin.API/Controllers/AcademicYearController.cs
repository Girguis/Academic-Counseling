using FOS.Core.IRepositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class AcademicYearController : ControllerBase
    {
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly ILogger<AcademicYearController> logger;

        public AcademicYearController(IAcademicYearRepo academicYearRepo, ILogger<AcademicYearController> logger)
        {
            this.academicYearRepo = academicYearRepo;
            this.logger = logger;
        }
        [HttpPost("StartNewAcademicYear")]
        public IActionResult StartNewAcademicYear()
        {
            try
            {
                var res = academicYearRepo.StartNewYear();
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error Occured while starting a new academic year"
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
