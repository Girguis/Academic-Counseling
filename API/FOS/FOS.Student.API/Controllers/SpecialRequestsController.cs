using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.Configs;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
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
        private readonly IProgramTransferRequestRepo programTransferRequestRepo;
        private readonly IDbContext config;
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
            IProgramTransferRequestRepo programTransferRequestRepo,
            IDbContext config,
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
            this.programTransferRequestRepo = programTransferRequestRepo;
            this.config = config;
            this.logger = logger;
        }
        [HttpGet("GetMyCoursesRequests")]
        [ProducesResponseType(200, Type = typeof(List<CourseRequestOutModel>))]
        public IActionResult GetMyCoursesRequests()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = Resource.InvalidID
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var res = courseRequestRepo.GetRequests(new CourseRequestParamModel { StudentID = student.Id });
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
                    return BadRequest(new { Massage = Resource.IDCantBeEmpty });
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = Resource.InvalidID
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                bool isDeleted = courseRequestRepo.DeleteRequest(requestID, student.Id);
                if (!isDeleted)
                    return BadRequest(new { Massage = Resource.ErrorOccurred });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetMyProgramTransferRequest")]
        [ProducesResponseType(200, Type = typeof(List<ProgramTransferRequestOutModel>))]
        public IActionResult GetMyProgramTransferRequest()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = Resource.InvalidID
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var res = programTransferRequestRepo.GetRequests(studentID: student.Id).FirstOrDefault();
                return Ok(res);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpDelete("DeleteProgramTransferRequest")]
        public IActionResult DeleteProgramTransferRequest()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = Resource.InvalidID
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                bool isDeleted = programTransferRequestRepo.DeleteRequest(student.Id);
                if (!isDeleted)
                    return BadRequest(new { Massage = Resource.ErrorOccurred });
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
                        Massage = Resource.InvalidID
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.AddAndDeleteCourse)
                    )
                    return Ok(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseAddDelete)
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var res = studentCoursesRepo.GetCoursesForAddAndDelete(student.Id);
                int? allowedHoursToRegister = Helper.GetAllowedHoursToRegister(academicYearRepo, configuration, student, programDistributionRepo);
                if (!allowedHoursToRegister.HasValue) allowedHoursToRegister = 0;
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
                        Massage = Resource.InvalidID
                    });
                if (model.ToAdd == null &&
                    model.ToAdd.Count == 0 &&
                    model.ToDelete == null &&
                    model.ToDelete.Count == 0)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = Resource.EmptyList
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseAddDelete)
                    });
                var res = studentCoursesRepo.RequestAddAndDelete(student.Id, model);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.ErrorOccurred
                    });
                return Ok(new
                {
                    Massgse = Resource.Done
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
                        Massage = Resource.InvalidID
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.CourseWithdraw)
                    )
                    return BadRequest(new
                    {
                        isAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseWithdraw)
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (student.AvailableWithdraws < 1)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.AllWithdrawUsed
                    });
                var courses = studentCoursesRepo.GetCoursesForWithdraw(student.Id);
                if (courses == null || courses.Count < 1 || 
                    courses.Sum(x => x.CreditHours) - courses.Min(x => x.CreditHours) < 12)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.CantWithdraw
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
                        Massage = Resource.InvalidID
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = Resource.EmptyList
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (student.AvailableWithdraws - model.CoursesList.Count < 0)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = string.Format(Resource.NotEnoughWithdrawChances,
                        student.AvailableWithdraws, model.CoursesList.Count)
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseWithdraw)
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.Withdraw, student.Id, model, (int)CourseOperationEnum.Deletion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.ErrorOccurred
                    });
                return Ok(new
                {
                    Massgse = Resource.Done
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpGet("CoursesExcuse")]
        public IActionResult CoursesExcuse()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        isAvailable = false,
                        Massage = Resource.InvalidID
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.CourseExcuse)
                    )
                    return BadRequest(new
                    {
                        isAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseExcuse)
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
               var courses = studentCoursesRepo.GetCoursesForWithdraw(student.Id);
                return Ok(new
                {
                    IsAvailable = true,
                    Courses = courses,
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPost("CoursesExcuse")]
        public IActionResult CoursesExcuse(CoursesLstParamModel model)
        {
            try
            {
                string guid = this.Guid();
                var regDate = dateRepo.IsInRegisrationInterval((int)DateForEnum.CourseExcuse);
                if (string.IsNullOrWhiteSpace(guid))
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = Resource.InvalidID
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = Resource.EmptyList
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseWithdraw)
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.Excuse, student.Id, model, (int)CourseOperationEnum.Deletion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.ErrorOccurred
                    });
                return Ok(new
                {
                    Massgse = Resource.Done
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
                        Massage = Resource.InvalidID
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.Overload)
                    )
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseOverload)
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                bool parsed = float.TryParse(QueryExecuterHelper.ExecuteFunction(config.CreateInstance(), "GetLastRegularSemesterGpa", student.Id.ToString())?.ToString(), out float sgpa);
                if (!parsed)
                    sgpa = 0;
                if (sgpa < 3)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = Resource.GpaAbove3
                    });
                var (RegisteredHours, courses, electiveCoursesDistribtion) = studentCoursesRepo.GetCoursesForOverload(student.Id);
                return Ok(new
                {
                    IsAvailable = true,
                    Courses = courses,
                    Distribution = electiveCoursesDistribtion,
                    RegisteredHours = RegisteredHours
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
                        Massage = Resource.InvalidID
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = Resource.EmptyList
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseOverload)
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.OverLoad, student.Id, model, (int)CourseOperationEnum.Addtion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.ErrorOccurred
                    });
                return Ok(new
                {
                    Massgse = Resource.Done
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
                        Massage = Resource.InvalidID
                    });
                var student = studentRepo.Get(guid, true);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (!student.Cgpa.HasValue
                    || !(student.Cgpa.Value < 2)
                    || !student.PassedHours.HasValue
                    || !(student.PassedHours >= student.CurrentProgram.TotalHours))
                    return BadRequest(new
                    {
                        Massage = Resource.CantEnrollEnhancementCourse
                    });
                if (student.AvailableEnhancementCredits < 1)
                    return BadRequest(new
                    {
                        Massage = Resource.NoEnhancementCredit
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.Enhancement)
                    )
                    return Ok(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseEnhancement)
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
                        Massage = Resource.InvalidID
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = Resource.EmptyList
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.CourseEnhancement)
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.Enhancement, student.Id, model, (int)CourseOperationEnum.Addtion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.ErrorOccurred
                    });
                return Ok(new
                {
                    Massgse = Resource.Done
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
                        Massage = Resource.InvalidID
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.OpenCourseForGraduation)
                    )
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.GraduationCourse)
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                int hours = ConfigurationsManager.TryGetNumber(Config.HoursForCourseOpeningForGraduation, 4);
                    if (!studentRepo.CanOpenCourseForGraduation(student.Id, student.PassedHours ?? byte.MinValue, student.CurrentProgramId ?? 0, hours))
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = Resource.For4thYearOnly
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
                        Massage = Resource.InvalidID
                    });
                if (model.CoursesList == null || model.CoursesList.Count < 1)
                    return BadRequest(new
                    {
                        IsAvailable = regDate,
                        Massage = Resource.EmptyList
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (!student.Level.HasValue || (student.Level.HasValue && student.Level.Value != 4))
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = Resource.For4thYearOnly
                    });

                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.GraduationCourse)
                    });
                var res = studentCoursesRepo.RequestCourse((int)CourseRequestEnum.OpenCourse, student.Id, model, (int)CourseOperationEnum.Addtion);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.ErrorOccurred
                    });
                return Ok(new
                {
                    Massgse = Resource.Done
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
                        Massage = Resource.InvalidID
                    });
                if (!dateRepo.IsInRegisrationInterval
                    ((int)DateForEnum.ProgramTransfer)
                    )
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.ProgramTransfer)
                    });
                var student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
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
                        Massage = Resource.InvalidID
                    });
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        IsAvailable = regDate,
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (!regDate)
                    return BadRequest(new
                    {
                        IsAvailable = false,
                        Massage = string.Format(Resource.NotAvailable, Resource.ProgramTransfer)
                    });
                var res = studentProgramRepo.ProgramTransferRequest(student.Id, model);
                if (!res)
                    return BadRequest(new
                    {
                        IsAvailable = true,
                        Massage = Resource.ErrorOccurred
                    });
                return Ok(new
                {
                    Massgse = Resource.Done
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
