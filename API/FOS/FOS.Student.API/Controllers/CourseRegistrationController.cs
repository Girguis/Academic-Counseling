using FOS.App.Helpers;
using FOS.App.Students.DTOs;
using FOS.App.Students.Mappers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
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
    public class CourseRegistrationController : ControllerBase
    {
        private readonly ILogger<CourseRegistrationController> logger;
        private readonly IStudentRepo studentRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IElectiveCourseDistributionRepo optionalCourseRepo;
        private readonly IDateRepo dateRepo;
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IProgramDistributionRepo programDistributionRepo;
        private readonly IConfiguration configuration;

        public CourseRegistrationController(ILogger<CourseRegistrationController> logger,
            IStudentRepo studentRepo,
            IStudentCoursesRepo studentCoursesRepo,
            IElectiveCourseDistributionRepo optionalCourseRepo,
            IDateRepo dateRepo,
            IAcademicYearRepo academicYearRepo,
            IProgramDistributionRepo programDistributionRepo,
            IConfiguration configuration)
        {
            this.logger = logger;
            this.studentRepo = studentRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.optionalCourseRepo = optionalCourseRepo;
            this.dateRepo = dateRepo;
            this.academicYearRepo = academicYearRepo;
            this.programDistributionRepo = programDistributionRepo;
            this.configuration = configuration;
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

                if (!dateRepo.IsInRegisrationInterval((int)DateForEnum.CourseRegistration))
                    return Ok(new Response
                    {
                        isRegistrationAvailable = false,
                        Data = null,
                        Massage = "Course registration is not available"
                    });

                var courses = studentCoursesRepo.GetCoursesForRegistration(student.Id);
                Dictionary<string, StudentCoursesOutModel> selectedCourses = studentCoursesRepo.GetCurrentAcademicYearCourses(student.Id).ToDictionary(x => x.CourceCode, z => z);
                for (int i = 0; i < courses.Count; i++)
                {
                    selectedCourses.TryGetValue(courses.ElementAt(i).CourseCode, out StudentCoursesOutModel res);
                    courses.ElementAt(i).IsSelected = res != null;
                }
                var optionalCoursesDTO = Helper.GetElectiveCoursesDistribution(optionalCourseRepo, courses.Select(x => x.Level).Distinct(), courses.Select(x => x.Semester).Distinct(), student.Id);
                var allowedHoursToRegister = Helper.GetAllowedHoursToRegister(academicYearRepo, configuration, student, programDistributionRepo);
                return Ok(new Response
                {
                    isRegistrationAvailable = true,
                    Massage = "",
                    Data = new
                    {
                        Courses = courses,
                        Distribution = optionalCoursesDTO,
                        AllowedHours = allowedHoursToRegister
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
        public IActionResult RegisterCourses(HashSet<int> courseIDs)
        {
            try
            {
                string guid = this.Guid();
                var regDate = dateRepo.IsInRegisrationInterval((int)DateForEnum.CourseRegistration);
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = regDate,
                        Data = null,
                        Massage = "ID not found"
                    });
                if (courseIDs == null || courseIDs.Count == 0)
                    return Ok(new Response
                    {
                        isRegistrationAvailable = regDate,
                        Data = null,
                        Massage = "List is empty"
                    });
                DB.Models.Student student = studentRepo.Get(guid);
                if (student == null)
                    return BadRequest(new Response
                    {
                        isRegistrationAvailable = regDate,
                        Data = null,
                        Massage = "Student not found"
                    });

                if (!regDate)
                    return Ok(new Response
                    {
                        isRegistrationAvailable = false,
                        Data = null,
                        Massage = "Course registration is not available"
                    });
                short academicYearID = academicYearRepo.GetCurrentYear().Id;
                if (!studentCoursesRepo.RegisterCourses(student.Id, academicYearID, courseIDs.ToList()))
                    return Ok(new Response
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
