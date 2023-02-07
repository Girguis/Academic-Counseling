using FOS.App.Student.DTOs;
using FOS.App.Student.Mappers;
using FOS.Core.IRepositories;
using FOS.DB.Models;
using FOS.Student.API.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class StudentCoursesController : ControllerBase
    {
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IStudentRepo studentRepo;
        private readonly IElectiveCourseDistributionRepo optionalCourseRepo;
        private readonly ILogger logger;

        public StudentCoursesController(IAcademicYearRepo academicYearRepo,
                                        IStudentCoursesRepo studentCoursesRepo,
                                        IStudentRepo studentRepo,
                                        IElectiveCourseDistributionRepo optionalCourseRepo,
                                        ILogger<StudentCoursesController> logger)
        {
            this.academicYearRepo = academicYearRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.studentRepo = studentRepo;
            this.optionalCourseRepo = optionalCourseRepo;
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
                    return BadRequest("Invalid Student ID");

                DB.Models.Student student = studentRepo.Get(guid);
                if (student == null)
                    return BadRequest("Student Not Found");

                List<AcademicYear> academicYears = academicYearRepo.GetAll(student.Id);
                List<AcademicYearsDTO> academicYearsDTO = new List<AcademicYearsDTO>();
                for (int i = 0; i < academicYears.Count; i++)
                {
                    double? sgpa = academicYearRepo.GetAcademicYearGPA(student.Id, academicYears.ElementAt(i).Id);
                    sgpa = sgpa != null ? Math.Round(sgpa.Value, 4) : sgpa;
                    academicYearsDTO.Add(academicYears.ElementAt(i).ToDTO(sgpa));
                }
                return Ok(academicYearsDTO);
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
        [ProducesResponseType(200, Type = typeof(List<StudentCoursesDTO>))]
        public IActionResult GetAcademicYearDetails(short academicYearID)
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrEmpty(guid))
                    return BadRequest("Invalid Student ID");

                DB.Models.Student student = studentRepo.Get(guid);
                if (student == null)
                    return BadRequest("Student Not Found");

                List<StudentCourse> cources = studentCoursesRepo.GetCoursesByAcademicYear(student.Id, academicYearID);
                List<StudentCoursesDTO> courcesDTO = new List<StudentCoursesDTO>();
                for (int i = 0; i < cources.Count; i++)
                    courcesDTO.Add(cources.ElementAt(i).ToDTO());

                return Ok(courcesDTO);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
