using FOS.App.Doctor.DTOs;
using FOS.App.Doctor.Mappers;
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
                var datesDto = new List<DateDTO>();
                for (int i = 0; i < dates.Count; i++)
                    datesDto.Add(dates.ElementAt(i).ToDTO());
                return Ok(new
                {
                    Data = datesDto
                });
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
                var dateDto = date.ToDTO();
                return Ok(new
                {
                    Data = dateDto
                });
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
                if (date.StartDate > date.EndDate || date.StartDate == date.EndDate)
                    return BadRequest(new { Massage = "Start date can't be greater or equal to end date" });
               
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
