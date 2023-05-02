using FOS.Core.Languages;
using FOS.App.PDFCreators;
using FOS.Core.IRepositories;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.StudentDTOs;
using FOS.DB.Models;
using FOS.Students.API.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Students.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class StudentCoursesController : ControllerBase
    {
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IStudentRepo studentRepo;
        private readonly ILogger logger;

        public StudentCoursesController(IStudentCoursesRepo studentCoursesRepo,
                                        IStudentRepo studentRepo,
                                        ILogger<StudentCoursesController> logger)
        {
            this.studentCoursesRepo = studentCoursesRepo;
            this.studentRepo = studentRepo;
            this.logger = logger;
        }
        /// <summary>
        /// Get a list of academic years which student enrolled 1 course or more in it
        /// each academic year will have it's details (year,semester) and Semester GPA for the student
        /// </summary>
        /// <returns>List of AcademicYearsDTO</returns>
        [HttpGet("GetAcademicYearsSummary")]
        [ProducesResponseType(200, Type = typeof(List<AcademicYearsDTO>))]
        public IActionResult GetAcademicYearsSummary()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrEmpty(guid))
                    return BadRequest(new
                    {
                        Massage = Resource.InvalidID
                    });

                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var data = studentRepo.GetStudentAcademicYearsSummary(student.Id);
                return Ok(data);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        /// <summary>
        /// Get all courses deatils for the academic year using it's academicYearID
        /// </summary>
        /// <param name="academicYearID"></param>
        /// <returns>List of StudentCoursesDTO</returns>
        [HttpGet("GetAcademicYearDetails")]
        [ProducesResponseType(200, Type = typeof(List<StudentCoursesOutModel>))]
        public IActionResult GetAcademicYearDetails(short academicYearID)
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrEmpty(guid))
                    return BadRequest(new
                    {
                        Massage = Resource.InvalidID
                    });

                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });

                var cources = studentCoursesRepo.GetCoursesByAcademicYear(student.Id, academicYearID);
                return Ok(cources);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetAcademicReportPDF")]
        public IActionResult GetAcademicReportPDF()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrEmpty(guid))
                    return BadRequest(new
                    {
                        Massage = Resource.InvalidID
                    });
                Student student = studentRepo.Get(guid, true);
                if (student == null)
                    return NotFound(new { Massage = string.Format(Resource.DoesntExist, Resource.Student) });
                var reportData = studentRepo.GetAcademicDetailsForReport(student.Id);
                var bytes = StudentAcademicReportPDF.CreateAcademicReport(reportData);
                return File(bytes,
                "application/pdf",
                string.Concat(student.Name, "_AcademicReport.pdf")
                );
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
