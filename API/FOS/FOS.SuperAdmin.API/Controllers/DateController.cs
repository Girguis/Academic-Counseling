using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctor.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class DateController : ControllerBase
    {
        private readonly IDateRepo dateRepo;
        private readonly ILogger<DateController> logger;

        public DateController(IDateRepo dateRepo, ILogger<DateController> logger)
        {
            this.dateRepo = dateRepo;
            this.logger = logger;
        }

        [HttpGet("GetDates")]
        public IActionResult GetDates()
        {
            try
            {
                var dates = dateRepo.GetDates();
                return Ok(dates);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpGet("GetDate/{id}")]
        public IActionResult GetDate(int id)
        {
            try
            {
                if (id < 0)
                    return NotFound();
                var date = dateRepo.GetDate(id);
                if (date == null)
                    return NotFound();
                return Ok(date);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPatch("UpdateDate")]
        public IActionResult Update(Date date)
        {
            try
            {
                var res = dateRepo.UpdateDate(date.DateFor, date.StartDate, date.EndDate);
                if (!res)
                    return BadRequest();
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
    }
}
