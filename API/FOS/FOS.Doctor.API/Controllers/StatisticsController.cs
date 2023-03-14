using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class StatisticsController : Controller
    {
        private readonly ILogger<StatisticsController> logger;
        private readonly IStatisticsRepo statisticsRepo;
        public StatisticsController(ILogger<StatisticsController> logger,
            IStatisticsRepo statisticsRepo)
        {
            this.logger = logger;
            this.statisticsRepo = statisticsRepo;
        }

        /// <summary>
        /// Get count of males and females
        /// </summary>
        /// <returns></returns>
        [HttpPost("GenderStatistics")]
        public IActionResult GenderStatistics()
        {
            try
            {
                return Ok(statisticsRepo.GetGendersStatistics());
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
        [HttpPost("ProgramStatistics")]
        public IActionResult ProgramStatistics()
        {
            try
            {
                return Ok(statisticsRepo.GetProgramsStatistics());
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("StudentsGPAStatistics")]
        public IActionResult StudentsGPAStatistics(StudentsGradesParatmeterModel model)
        {
            try
            {
                return Ok(statisticsRepo.GetStudentsGradesStatistics(model));
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("CourseStatistics")]
        public IActionResult CourseStatistics(CourseStatisticsParameterModel model)
        {
            try
            {
                return Ok(statisticsRepo.GetCourseStatistics(model));
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
