using FOS.App.Student.DTOs;
using FOS.App.Student.Mappers;
using FOS.App.Student.Repositories;
using FOS.Core.IRepositories.Student;
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
    public class CourseRegistrationController : ControllerBase
    {
        private readonly ILogger<CourseRegistrationController> logger;
        private readonly IStudentRepo studentRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IOptionalCourseRepo optionalCourseRepo;
        private readonly IDateRepo dateRepo;
        private readonly IAcademicYearRepo academicYearRepo;

        public CourseRegistrationController(ILogger<CourseRegistrationController> logger,
            IStudentRepo studentRepo,
            IStudentCoursesRepo studentCoursesRepo,
            IOptionalCourseRepo optionalCourseRepo,
            IDateRepo dateRepo,
            IAcademicYearRepo academicYearRepo)
        {
            this.logger = logger;
            this.studentRepo = studentRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.optionalCourseRepo = optionalCourseRepo;
            this.dateRepo = dateRepo;
            this.academicYearRepo = academicYearRepo;
        }

        [HttpGet("GetCoursesForRegistration")]
        public IActionResult GetCoursesForRegistration()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = false,
                        Data = null,
                        Massage = "ID not found"
                    });

                DB.Models.Student student = studentRepo.Get(guid);
                if (student == null)
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = false,
                        Data = null,
                        Massage = "Student not found"
                    });

                if (!dateRepo.IsInRegisrationInterval(1))
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = false,
                        Data = null,
                        Massage = "Course registration is not available"
                    });

                List<ProgramCourse> courses = studentCoursesRepo.GetCoursesForRegistration(student.Id);
                Dictionary<int, StudentCourse> selectedCourses = studentCoursesRepo.GetCurrentAcademicYearCourses(student.Id).ToDictionary(x => x.CourseId, z => z);
                List<CourseRegistrationDTO> coursesDTOs = new();
                for (int i = 0; i < courses.Count; i++)
                {
                    coursesDTOs.Add(courses.ElementAt(i).ToCourseRegisrationDTO());
                    selectedCourses.TryGetValue(coursesDTOs.ElementAt(i).Id, out StudentCourse res);
                    coursesDTOs.ElementAt(i).IsSelected = res != null;
                }
                List<byte> levels = coursesDTOs.Select(x => x.Level).Distinct().ToList();
                List<byte> semesters = coursesDTOs.Select(x => x.Semester).Distinct().ToList();
                List<OptionalCourse> optionalCoursesDistribution = optionalCourseRepo
                                                    .GetOptionalCoursesDistibution
                                                    (studentRepo.GetCurrentProgram(guid).Id)
                                                    .Where(x => levels.Any(z => z == x.Level) && semesters.Any(z => z == x.Semester))
                                                    .ToList();
                List<OptionalCourseDTO> optionalCoursesDTO = new();
                for (int i = 0; i < optionalCoursesDistribution.Count; i++)
                    optionalCoursesDTO.Add(optionalCoursesDistribution.ElementAt(i).ToDTO());

                return Ok(new Response
                {
                    isRegistrationAvailable = true,
                    Massage = "",
                    Data = new
                    {
                        Courses = coursesDTOs,
                        Distribution = optionalCoursesDTO,
                        AllowedHours = 19
                    }
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("RegisterCourses")]
        public IActionResult RegisterCourses(List<int> courseIDs)
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = false,
                        Data = null,
                        Massage = "ID not found"
                    });

                DB.Models.Student student = studentRepo.Get(guid);
                if (student == null)
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = false,
                        Data = null,
                        Massage = "Student not found"
                    });

                if (!dateRepo.IsInRegisrationInterval(1))
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = false,
                        Data = null,
                        Massage = "Course registration is not available"
                    });
                short academicYearID = academicYearRepo.GetCurrentYear().Id;
                if (!studentCoursesRepo.RegisterCourses(student.Id, academicYearID, courseIDs))
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = true,
                        Massage = "Error Occured While Adding Courses",
                        Data = courseIDs
                    });

                return Ok(new Response
                {
                    isRegistrationAvailable = true,
                    Massage = "Done"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        class Response
        {
            public bool isRegistrationAvailable { get; set; }
            public string Massage { get; set; }
            public Object Data { get; set; }
        }
    }
}
