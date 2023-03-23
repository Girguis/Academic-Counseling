using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
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
    public class SpecialRequestsController : ControllerBase
    {
        private readonly IDateRepo dateRepo;
        private readonly IStudentRepo studentRepo;
        private readonly IProgramDistributionRepo programDistributionRepo;
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IConfiguration configuration;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IStudentProgramRepo studentProgramRepo;
        private readonly ICourseRequestRepo courseRequestRepo;
        private readonly ILogger<SpecialRequestsController> logger;

        public SpecialRequestsController(
            IDateRepo dateRepo,
            IStudentRepo studentRepo,
            IProgramDistributionRepo programDistributionRepo,
            IAcademicYearRepo academicYearRepo,
            IConfiguration configuration,
            IStudentCoursesRepo studentCoursesRepo,
            IStudentProgramRepo studentProgramRepo,
            ICourseRequestRepo courseRequestRepo,
            ILogger<SpecialRequestsController> logger
            )
        {
            this.dateRepo = dateRepo;
            this.studentRepo = studentRepo;
            this.programDistributionRepo = programDistributionRepo;
            this.academicYearRepo = academicYearRepo;
            this.configuration = configuration;
            this.studentCoursesRepo = studentCoursesRepo;
            this.studentProgramRepo = studentProgramRepo;
            this.courseRequestRepo = courseRequestRepo;
            this.logger = logger;
        }
        [HttpGet("GetMyCoursesRequests")]
        public IActionResult GetMyCoursesRequests()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = "ID not found"
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = "Student Not Found"
                    });
                var res = courseRequestRepo.GetRequests(new CourseRequestParamModel { StudentID = student.Id });
                for (int i = 0; i < res.Count; i++)
                {
                    res.ElementAt(i).CourseOperation = res.ElementAt(i).CourseOperationID == true ? Helper.GetEnumDescription(CourseOperationEnum.Addtion) : Helper.GetEnumDescription(CourseOperationEnum.Deletion);
                    res.ElementAt(i).RequestType = Helper.GetEnumDescription((CourseRequestEnum)res.ElementAt(i).RequestTypeID);
                }
                return Ok(res);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpDelete("DeleteCourseRequest/{requestID}")]
        public IActionResult DeleteCourseRequest(string requestID)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(requestID))
                    return BadRequest(new { Massage = "RequestID can't be empty" });
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = "ID not found"
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = "Student Not Found"
                    });
                bool isDeleted = courseRequestRepo.DeleteRequest(requestID, student.Id);
                if (!isDeleted)
                    return BadRequest(new { Massage = "Error occured while deleting request" });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("AddAndDeleteCourses")]
        public IActionResult AddAndDeleteCourses()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = "ID not found"
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.AddAndDeleteCourse)
                    )
                    return Ok(new
                    {
                        IsAvailable = false,
                        Massage = "Course add and delete is not available"
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = "Student Not Found"
                    });
                var res = studentCoursesRepo.GetCoursesForAddAndDelete(student.Id);
                var allowedHoursToRegister = Helper.GetAllowedHoursToRegister(academicYearRepo, configuration, student, programDistributionRepo);
                return Ok(new
                {
                    IsAvailable = true,
                    ToAddCourses = res.toAdd,
                    ToDeleteCourses = res.toDelete,
                    ElectiveCoursesDistribtion = res.electiveCoursesDistribtion,
                    AllowedHoursToRegister = allowedHoursToRegister,
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPost("AddAndDeleteCourses")]
        public IActionResult AddAndDeleteCourses(AddAndDeleteCoursesParamModel model)
        {
            try
            {
                string guid = this.Guid();
                var regDate = dateRepo.IsInRegisrationInterval((int)DateForEnum.AddAndDeleteCourse);
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        isRegistrationAvailable = regDate,
                        Massage = "ID not found"
                    });
                if (model.ToAdd == null &&
                    model.ToAdd.Count == 0 &&
                    model.ToDelete == null &&
                    model.ToDelete.Count == 0)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = "Lists are empty"
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = "Student not found"
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Course registration is not available"
                    });
                var res = studentCoursesRepo.RequestAddAndDelete(student.Id, model);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = "Error occured while submiting your request"
                    });
                return Ok(new
                {
                    Massgse = "Done"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpGet("CoursesWithdraw")]
        public IActionResult CoursesWithdraw()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        isAvailable = false,
                        Massage = "ID not found"
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.CourseWithdraw)
                    )
                    return BadRequest(new
                    {
                        isAvailable = false,
                        Massage = "Course withdraw is not available"
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = "Student Not Found"
                    });
                if (student.AvailableWithdraws < 1)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = "You have used all of your withdraw chances"
                    });
                var courses = studentCoursesRepo.GetCoursesForWithdraw(student.Id);
                if (courses.Sum(x => x.CreditHours) - courses.Min(x => x.CreditHours) < 12
                    || courses.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = "You can't withdraw from any course"
                    });
                return Ok(new
                {
                    IsAvailable = true,
                    Courses = courses,
                    AvailableWithdraws = student.AvailableWithdraws
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPost("CoursesWithdraw")]
        public IActionResult CoursesWithdraw(CoursesLstParamModel model)
        {
            try
            {
                string guid = this.Guid();
                var regDate = dateRepo.IsInRegisrationInterval((int)DateForEnum.CourseWithdraw);
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = "ID not found"
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = "List is empty"
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = "Student not found"
                    });
                if (student.AvailableWithdraws - model.CoursesList.Count < 0)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = "You have only " + student.AvailableWithdraws
                        + " chances and you requested for " + model.CoursesList.Count
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Course withdraw is not available"
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.Withdraw, student.Id, model, (int)CourseOperationEnum.Deletion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = "Error occured while submiting your request"
                    });
                return Ok(new
                {
                    Massgse = "Done"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpGet("CoursesOverload")]
        public IActionResult CoursesOverload()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = "ID not found"
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.Overload)
                    )
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Course overload is not available"
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = "Student Not Found"
                    });
                bool parsed = float.TryParse(QueryExecuterHelper.ExecuteFunction(configuration["ConnectionStrings:FosDB"], "GetLastRegularSemesterGpa", new List<object>() { student.Id })?.ToString(), out float sgpa);
                if (!parsed)
                    sgpa = 0;
                if (sgpa < 3)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Last regular SGPA must be >= 3.0"
                    });
                var result = studentCoursesRepo.GetCoursesForOverload(student.Id);
                var courses = result.courses;
                courses.RemoveAll(x =>
                    result.electiveCoursesDistribtion.Any(z =>
                    z.Level == x.Level && z.CourseType == x.CourseType &&
                    z.Semester == x.Semester && z.Category == x.Category && z.Hour == 0
                    )
                    ||
                    (x.CreditHours - result.electiveCoursesDistribtion.FirstOrDefault(z =>
                        z.Level == x.Level && z.CourseType == x.CourseType &&
                        z.Semester == x.Semester && z.Category == x.Category).Hour < 0
                    )
                );
                result.electiveCoursesDistribtion.RemoveAll(x => x.Hour == 0);
                return Ok(new
                {
                    IsAvailable = true,
                    Courses = courses,
                    Distribution = result.electiveCoursesDistribtion,
                    RegisteredHours = result.RegisteredHours
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPost("CoursesOverload")]
        public IActionResult CoursesOverload(CoursesLstParamModel model)
        {
            try
            {
                string guid = this.Guid();
                var regDate = dateRepo.IsInRegisrationInterval((int)DateForEnum.Overload);
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        isRegistrationAvailable = regDate,
                        Massage = "ID not found"
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = "List is empty"
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = "Student not found"
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Course overload is not available"
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.OverLoad, student.Id, model, (int)CourseOperationEnum.Addtion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = "Error occured while submiting your request"
                    });
                return Ok(new
                {
                    Massgse = "Done"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpGet("EnhancementCourses")]
        public IActionResult EnhancementCourses()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = "ID not found"
                    });
                var student = studentRepo.Get(guid, true);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = "Student Not Found"
                    });
                if (!student.Cgpa.HasValue
                    || !(student.Cgpa.Value < 2)
                    || !student.PassedHours.HasValue
                    || !(student.PassedHours >= student.CurrentProgram.TotalHours))
                    return BadRequest(new
                    {
                        Massage = "you can't enroll in an enhancement course"
                    });
                if (student.AvailableEnhancementCredits < 1)
                    return BadRequest(new
                    {
                        Massage = "You don't have any available enhancement credits left"
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.Enhancement)
                    )
                    return Ok(new
                    {
                        IsAvailable = false,
                        Massage = "Course Enhancement is not available"
                    });
                var (courses, electiveCoursesDistribtion) =
                    studentCoursesRepo.GetCoursesForEnhancement(student.Id);
                return Ok(new
                {
                    IsAvailable = true,
                    Courses = courses,
                    Distribution = electiveCoursesDistribtion
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPost("EnhancementCourses")]
        public IActionResult EnhancementCourses(CoursesLstParamModel model)
        {
            try
            {
                string guid = this.Guid();
                var regDate = dateRepo.IsInRegisrationInterval((int)DateForEnum.Enhancement);
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        isRegistrationAvailable = regDate,
                        Massage = "ID not found"
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = "List is empty"
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = "Student not found"
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Course enhancement is not available"
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.Enhancement, student.Id, model, (int)CourseOperationEnum.Addtion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = "Error occured while submiting your request"
                    });
                return Ok(new
                {
                    Massgse = "Done"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpGet("CoursesForGraduation")]
        public IActionResult CoursesForGraduation()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = "ID not found"
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.OpenCourseForGraduation)
                    )
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Course opening for gradution is not available"
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = "Student Not Found"
                    });
                if (!student.Level.HasValue || (student.Level.HasValue && student.Level.Value != 4))
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Available for 4th level students only"
                    });
                var result = studentCoursesRepo.GetCoursesForGraduation(student.Id);
                return Ok(new
                {
                    IsAvailable = true,
                    Courses = result.courses,
                    Distribution = result.electiveCoursesDistribtion
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPost("CoursesForGraduation")]
        public IActionResult CoursesForGraduation(CoursesLstParamModel model)
        {
            try
            {
                string guid = this.Guid();
                var regDate = dateRepo.IsInRegisrationInterval((int)DateForEnum.OpenCourseForGraduation);
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        isRegistrationAvailable = regDate,
                        Massage = "ID not found"
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = "List is empty"
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = "Student not found"
                    });
                if (!student.Level.HasValue || (student.Level.HasValue && student.Level.Value != 4))
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Available for 4th level students only"
                    });

                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Course opening for graduation is not available"
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.OpenCourse, student.Id, model, (int)CourseOperationEnum.Addtion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = "Error occured while submiting your request"
                    });
                return Ok(new
                {
                    Massgse = "Done"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }

        [HttpGet("ProgramTransfer")]
        public IActionResult ProgramTransfer()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = "ID not found"
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.ProgramTransfer)
                    )
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Program transfer is not available"
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = "Student Not Found"
                    });
                var programs = studentProgramRepo.GetProgramsListForProgramTransfer(student.CurrentProgramId.Value);
                return Ok(new
                {
                    IsAvailable = true,
                    ProgramList = programs
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPost("ProgramTransfer")]
        public IActionResult ProgramTransfer(ProgramTransferParamModel model)
        {
            try
            {
                string guid = this.Guid();
                var regDate = dateRepo.IsInRegisrationInterval((int)DateForEnum.ProgramTransfer);
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        isRegistrationAvailable = regDate,
                        Massage = "ID not found"
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = "Student not found"
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = "Program Transfer is not available"
                    });
                var res = studentProgramRepo.ProgramTransferRequest(student.Id, model);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = "Error occured while submiting your request"
                    });
                return Ok(new
                {
                    Massgse = "Done"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }

    }
}
