﻿using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
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
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult StartNewAcademicYear()
        {
            try
            {
                var res = academicYearRepo.StartNewYear();
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetCurrentAcademicYear")]
        public IActionResult GetCurrentAcademicYear()
        {
            try
            {
                var academicYear = academicYearRepo.GetCurrentYear();
                if (academicYear == null)
                    return NotFound();
                return Ok(new
                {
                    AcademicYear =
                        string.Concat(academicYear.AcademicYear1, " - ", Helper.GetDisplayName((SemesterEnum)academicYear.Semester))
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
