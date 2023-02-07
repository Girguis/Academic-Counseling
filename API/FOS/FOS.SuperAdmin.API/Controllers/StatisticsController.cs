using FOS.Core.IRepositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctor.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class StatisticsController : Controller
    {
        private readonly ILogger<StatisticsController> logger;
        private readonly IStudentRepo studentRepo;
        private readonly IStudentProgramRepo programRepo;

        public StatisticsController(ILogger<StatisticsController> logger,
            IStudentRepo studentRepo,
            IStudentProgramRepo programRepo)
        {
            this.logger = logger;
            this.studentRepo = studentRepo;
            this.programRepo = programRepo;
        }

        /// <summary>
        /// Get count of males and females
        /// </summary>
        /// <returns></returns>
        [HttpGet("GenderStatistics")]
        public IActionResult GenderStatistics()
        {
            try
            {
                return Ok(studentRepo.GenderStatistics());
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        /// <summary>
        /// Get number of student in each program
        /// </summary>
        /// <returns></returns>
        [HttpGet("ProgramStatistics")]
        public IActionResult ProgramStatistics()
        {
            try
            {
                return Ok(programRepo.ProgramsStatistics());
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
