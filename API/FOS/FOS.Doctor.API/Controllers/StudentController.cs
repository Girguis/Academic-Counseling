using FirebaseAdmin.Messaging;
using FOS.App.ExcelReader;
using FOS.Core.Languages;
using FOS.App.PDFCreators;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.DTOs;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using FOS.Doctors.API.Extenstions;
using FOS.Doctors.API.Mappers;
using FOS.Doctors.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class StudentController : ControllerBase
    {
        private readonly IStudentRepo studentRepo;
        private readonly ILogger<StudentController> logger;
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IProgramRepo programRepo;
        private readonly ICourseRepo courseRepo;
        private readonly IStudentProgramRepo studentProgramRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly ICourseRequestRepo courseRequestRepo;
        private readonly IProgramTransferRequestRepo programTransferRequestRepo;

        public StudentController(IStudentRepo studentRepo,
            ILogger<StudentController> logger,
            IAcademicYearRepo academicYearRepo,
            IProgramRepo programRepo,
            ICourseRepo courseRepo,
            IStudentProgramRepo studentProgramRepo,
            IStudentCoursesRepo studentCoursesRepo,
            ICourseRequestRepo courseRequestRepo,
            IProgramTransferRequestRepo programTransferRequestRepo)
        {
            this.studentRepo = studentRepo;
            this.logger = logger;
            this.academicYearRepo = academicYearRepo;
            this.programRepo = programRepo;
            this.courseRepo = courseRepo;
            this.studentProgramRepo = studentProgramRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.courseRequestRepo = courseRequestRepo;
            this.programTransferRequestRepo = programTransferRequestRepo;
        }
        [HttpPost("Deactivate")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult Deactivate([FromBody] GuidModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.Guid)) return BadRequest(new
                {
                    Massage =Resource.InvalidID
                });
                var res = studentRepo.Deactivate(model.Guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
                        Data = model.Guid
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("Activate")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult Activate([FromBody] GuidModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.Guid)) return BadRequest(new
                {
                    Massage = Resource.InvalidID
                });
                var res = studentRepo.Activate(model.Guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
                        Data = model.Guid
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("GetStudents")]
        public IActionResult GetStudents(SearchCriteria criteria)
        {
            try
            {
                var result = studentRepo.GetAll(criteria, this.ProgramID());
                return Ok(new
                {
                    Data = result.students,
                    TotalCount = result.totalCount
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetCoursesRequests/{guid}")]
        public IActionResult GetCoursesRequests(string guid)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(guid)) return BadRequest(new
                {
                    Massage = Resource.InvalidID
                });
                var student = studentRepo.Get(guid);
                if (student == null) return NotFound();
                var requests = courseRequestRepo
                    .GetRequests(new CourseRequestParamModel { StudentID = student.Id })
                    .GroupBy(x => x.RequestID)
                    .Select(x => new { RequestID = x.Key, RequestData = x });
                return Ok(requests);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("HandleCourseRequest")]
        public IActionResult HandleCourseRequest(HandleCourseRequestParamModel model)
        {
            try
            {
                var handled = courseRequestRepo.HandleRequest(model.RequestID, model.IsApproved);
                if (!handled) return BadRequest(new
                {
                    Massage = Resource.ErrorOccured
                });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("GetProgramTranferRequests")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult GetProgramTranferRequests(ProgramTransferSearchParamModel model)
        {
            try
            {
                return Ok(programTransferRequestRepo.GetRequests(model));
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("HandleProgramTranferRequest")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult HandleProgramTranferRequest(ProgramTransferHandleParamModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.guid))
                    return NotFound(new
                    {
                        IsAvailable = false,
                        Massage = Resource.InvalidID
                    });
                var student = studentRepo.Get(model.guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                bool isDeleted = programTransferRequestRepo.HandleRequest(student.Id, model.IsApproved);
                if (!isDeleted)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        /// <summary>
        /// This one take GUID as paramter and check if there exist a student with the GUID or not
        /// if yes then retrive all enrolled courses and his programs and a list of his/her academic years
        /// then loop through academic years list
        /// get courses and program for that academic year and calculate CGpa and CHours
        /// then map it to AcademicYearDTO, then map that list to StudentAcademicReportDTO
        /// which includes student details with his Academic details
        /// </summary>
        /// <param name="guid"></param>
        /// <returns></returns>
        [HttpGet("GetAcademicDetails/{guid}")]
        [ProducesResponseType(200, Type = typeof(StudentAcademicReportDTO))]
        public IActionResult GetAcademicDetails(string guid)
        {
            try
            {
                Student student = studentRepo.Get(guid, true, true);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                return Ok(studentRepo.GetAcademicDetails(student));
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("ReadAcademicReport")]
        public IActionResult ReadAcademicReport(IFormFile file)
        {
            try
            {
                if (file.Length < 1 || !file.FileName.EndsWith(".xlsx"))
                {
                    return BadRequest(new { Massage = Resource.FileNotValid});
                }
                var academicYearsLst = academicYearRepo.GetAcademicYearsList();
                var programsLst = programRepo.GetPrograms();
                var coursesLst = courseRepo.GetAll();
                var sheet = AcademicReportReader.Read(file, studentRepo, academicYearsLst, programsLst, coursesLst);
                var courses = studentCoursesRepo.CompareStudentCourse(sheet.Item6, sheet.Item4);
                var toBeInserted = courses.Item1.Select(x => StudentCoursesModel.ToViewModel(x, academicYearsLst));
                var toBeRemoved = courses.Item2.Select(x => StudentCoursesModel.ToViewModel(x, academicYearsLst));
                var toBeUpdated = courses.Item4.Select(x => StudentCoursesUpdateModel.ToViewModel(x, courses.Item3, academicYearsLst));
                return Ok(new AcademicRecordModels
                {
                    Name = sheet.Item1,
                    SSN = sheet.Item2,
                    SeatNumber = sheet.Item3,
                    StudentPrograms = sheet.Item5,
                    ToBeInserted = toBeInserted.ToList(),
                    ToBeRemoved = toBeRemoved.ToList(),
                    ToBeUpdated = toBeUpdated.ToList()
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("UpdateFromAcademicReport")]
        public IActionResult UpdateFromAcademicReport(AcademicRecordModels model)
        {
            try
            {
                var student = studentRepo.GetBySSN(model.SSN);
                if (student == null)
                {
                    student = new StudentBasicModel()
                    {
                        Name = model.Name,
                        SeatNumber = model.SeatNumber,
                        Ssn = model.SSN
                    }.ToDbModel();
                    student = studentRepo.Add(student);
                }
                for (int i = 0; i < model.StudentPrograms.Count; i++)
                    model.StudentPrograms.ElementAt(i).StudentId = student.Id;
                var addPrograms = studentProgramRepo.AddStudentPrograms(model.StudentPrograms);
                if (!addPrograms)
                {
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
                        Data = model
                    });
                }
                var addCourses = studentCoursesRepo.UpdateStudentCourses(student.Id, model);
                if (!addCourses)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
                        Data = model
                    });
                return Ok(new
                {
                    Massage = "Updated"
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("ChangePassword/{guid}")]
        public IActionResult ChangePassword(string guid, ChangePasswordModel model)
        {
            try
            {
                var student = studentRepo.Get(guid);
                if (student == null) return NotFound(
                    new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var updated = studentRepo.ChangePassword(student.Id, model.Password);
                if (!updated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
                        Data = model
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("StudentCoursesSummary/{guid}")]
        public IActionResult StudentCoursesSummary(string guid)
        {
            try
            {
                var student = studentRepo.Get(guid);
                if (student == null) return NotFound(
                    new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var summary = studentRepo.GetStudentCoursesSummary(student.Id);
                if (summary == null || summary.Courses.Count() < 1) return NotFound();
                var summaryTree = studentRepo.GetStudentCoursesSummaryTree(student.Id);
                var stream = StudentCoursesSummaryReport.CreateCoursesSummarySheet(summary, summaryTree);
                return File(stream,
                    "application/vnd.ms-excel",
                    student.Name + "_CoursesSummary.xlsx");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("GetStruggledStudentsReport")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult GetStruggledStudentsReport(StruggledStudentsParamModel model)
        {
            try
            {
                var students = studentRepo.GetStruggledStudents(model);
                var stream = StruggledStudentsReport.Create(students);
                return File(stream,
                    "application/vnd.ms-excel",
                    "StruggledStudents_" + DateTime.UtcNow.AddHours(2).ToString() + ".xlsx");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetAcademicReportPDF/{guid}")]
        public IActionResult GetAcademicReportPDF(string guid)
        {
            try
            {
                Student student = studentRepo.Get(guid, true);
                if (student == null)
                    return NotFound(
                    new{
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var res = studentRepo.GetAcademicDetailsForReport(student.Id);
                var bytes = StudentAcademicReportPDF.CreateAcademicReport(student, res.academicYears, res.courses);
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
