﻿using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    //[Authorize]
    public class DropDownListsController : ControllerBase
    {
        private readonly ILogger<DropDownListsController> logger;
        private readonly IProgramRepo programRepo;
        private readonly ICourseRepo courseRepo;

        public DropDownListsController(ILogger<DropDownListsController> logger,
            IProgramRepo programRepo,
            ICourseRepo courseRepo)
        {
            this.logger = logger;
            this.programRepo = programRepo;
            this.courseRepo = courseRepo;
        }
        [HttpGet("GetCourseTypes")]
        public IActionResult GetCourseTypes()
        {
            try
            {
                var lst = Helper.EnumToList<CourseTypeEnum>();
                return Ok(lst);
            }
            catch(Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetDateTypes")]
        public IActionResult GetDateTypes()
        {
            try
            {
                var lst = Helper.EnumToList<DateForEnum>();
                return Ok(lst);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetDoctorTypes")]
        public IActionResult GetDoctorTypes()
        {
            try
            {
                var lst = Helper.EnumToList<DoctorTypesEnum>();
                return Ok(lst);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetCoursePreqsTypes")]
        public IActionResult GetCoursePreqsTypes()
        {
            try
            {
                var lst = Helper.EnumToList<PrerequisiteCoursesRelationEnum>();
                return Ok(lst);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetSemesterTypes")]
        public IActionResult GetSemesterTypes()
        {
            try
            {
                var lst = Helper.EnumToList<SemesterEnum>();
                return Ok(lst);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetProgramsList")]
        public IActionResult GetProgramsList()
        {
            try
            {
                var lst = Helper.ProgramsToList(programRepo.GetPrograms());
                return Ok(lst);
            }catch(Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetCoursesList")]
        public IActionResult GetCoursesList()
        {
            try
            {
                var lst = Helper.CoursesToList(courseRepo.GetAll());
                return Ok(lst);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}