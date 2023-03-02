using FOS.App.Doctors.DTOs;
using FOS.App.Doctors.Mappers;
using FOS.Core.IRepositories;
using FOS.Doctors.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Controllers
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
                logger.LogError(ex.ToString());
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
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPatch("Update/{id}")]
        public IActionResult Update(int id, DateModel model)
        {
            try
            {
                if (id < 0)
                    return NotFound();
                var date = dateRepo.GetDate(id);
                if (date == null) return NotFound();

                if (model.StartDate > model.EndDate || model.StartDate == model.EndDate)
                    return BadRequest(new { Massage = "Start date can't be greater or equal to end date" });

                var res = dateRepo.UpdateDate(id, model.StartDate.Value, model.EndDate.Value);
                if (!res)
                    return BadRequest();
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
