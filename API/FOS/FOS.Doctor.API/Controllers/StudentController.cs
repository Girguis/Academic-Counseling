using FOS.App.ExcelReader;
using FOS.App.Helpers;
using FOS.App.PDFCreators;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
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
        [HttpGet("GetNewStudentAddTemplate")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult GetNewStudentAddTemplate()
        {
            try
            {
                var stream = StudentsAddSheet.Create(programRepo.GetAllProgramsNames(1));
                return File(stream,
                    "application/vnd.ms-excel",
                    "NewStudentsAddTemplate.xlsx");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("AddNewStudentsViaExcel")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult AddNewStudentsViaExcel(IFormFile file)
        {
            try
            {
                if (file.Length < 1 || !file.FileName.EndsWith(".xlsx"))
                {
                    return BadRequest(new { Massage = Resource.FileNotValid });
                }
                var students = StudentsAddSheet.Read(file, programRepo.GetPrograms());
                if (students == null)
                    return BadRequest(new { Massage = Resource.FileNotValid });
                bool added = studentRepo.Add(students);
                if (!added)
                    return BadRequest(new { Massage = Resource.ErrorOccurred });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("GetReportByCgpa")]
        public IActionResult GetReportByCgpa(GetReportByCgpaParamModel model)
        {
            try
            {
                var students = studentRepo.ReportByCgpa(model);
                if (students == null || students.Count < 1)
                    return NotFound(new
                    {
                        Massage = Resource.NoData
                    });
                var stream = StudentsByCgpaReport.Create(model, students);
                return File(stream,
                    "application/vnd.ms-excel",
                    "StudentsReport_" + DateTime.UtcNow.AddHours(Helper.GetUtcOffset()).ToString() + ".xlsx");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("Deactivate")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult Deactivate([FromBody] GuidModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.Guid)) return BadRequest(new
                {
                    Massage = Resource.InvalidID
                });
                var res = studentRepo.Deactivate(model.Guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
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
                        Massage = Resource.ErrorOccurred,
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
        [Authorize(Roles = "SuperAdmin,ProgramAdmin,Supervisor")]
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
                    .Select(x => new
                    {
                        RequestID = x.Key,
                        x.FirstOrDefault()?.IsApproved,
                        x.FirstOrDefault()?.RequestType,
                        RequestData = x
                    });
                return Ok(requests);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("HandleCourseRequest")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin,Supervisor")]
        public IActionResult HandleCourseRequest(HandleCourseRequestParamModel model)
        {
            try
            {
                var handled = courseRequestRepo.HandleRequest(model.RequestID, model.IsApproved);
                if (!handled) return BadRequest(new
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
        [HttpPost("GetProgramTranferRequests")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult GetProgramTranferRequests(SearchCriteria criteria)
        {
            try
            {
                var (totalCount, requests) =
                    programTransferRequestRepo.GetRequests(criteria, this.ProgramID());
                return Ok(new
                {
                    Data = requests,
                    TotalCount = totalCount
                });
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
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult ReadAcademicReport(IFormFile file)
        {
            try
            {
                if (file.Length < 1 || !file.FileName.EndsWith(".xlsx"))
                    return BadRequest(new { Massage = Resource.FileNotValid });
                var academicYearsLst = academicYearRepo.GetAcademicYearsList();
                var programsLst = programRepo.GetPrograms();
                var coursesLst = courseRepo.GetAll();
                var (name, ssn, seatNumber, studentCourses, studentPrograms, studentID, semesterCounter)
                    = AcademicReportReader.Read(file, studentRepo, academicYearsLst, programsLst, coursesLst);
                if (string.IsNullOrEmpty(ssn) || string.IsNullOrEmpty(name) || seatNumber == 0)
                    return BadRequest(new { Massage = Resource.FileNotValid });
                var (toBeSavedLst, toBeRemovedLst, toBeUpdatedLst, toBeUpdatedOldMarksLst)
                    = studentCoursesRepo.CompareStudentCourse(studentID, studentCourses);
                var toBeInserted = toBeSavedLst.Select(x => StudentCoursesModel.ToViewModel(x, academicYearsLst));
                var toBeRemoved = toBeRemovedLst.Select(x => StudentCoursesModel.ToViewModel(x, academicYearsLst));
                var toBeUpdated = toBeUpdatedOldMarksLst.Select(x => StudentCoursesUpdateModel.ToViewModel(x, toBeUpdatedLst, academicYearsLst));
                return Ok(new AcademicRecordModels
                {
                    Name = name,
                    SSN = ssn,
                    SeatNumber = seatNumber,
                    NumberOfSemesters = semesterCounter,
                    StudentPrograms = studentPrograms,
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
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
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
                        Ssn = model.SSN,
                        NumberOfSemesters = model.NumberOfSemesters
                    }.ToDbModel();
                    student.EnrollYearId = (short)model.ToBeInserted.Min(x => x.AcademicYearID);
                    student = studentRepo.Add(student);
                }
                for (int i = 0; i < model.StudentPrograms.Count; i++)
                    model.StudentPrograms.ElementAt(i).StudentId = student.Id;
                var addPrograms = studentProgramRepo.AddStudentPrograms(model.StudentPrograms);
                if (!addPrograms)
                {
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = model
                    });
                }
                var addCourses = studentCoursesRepo.UpdateStudentCourses(student.Id, model);
                if (!addCourses)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
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
        [HttpPost("AddMultipleStudentsViaAcademicReport")]
        [Authorize(Roles = "SuperAdmin")]
        [RequestSizeLimit(int.MaxValue)]
        public IActionResult AddMultipleStudentsViaAcademicReport(List<IFormFile> files)
        {
            try
            {
                if (files.Count < 1 || !files.All(x => x != null && x.Length > 0 && x.FileName.EndsWith(".xlsx")))
                    return BadRequest(new { Massage = Resource.FileNotValid });
                var academicYearsLst = academicYearRepo.GetAcademicYearsList();
                var programsLst = programRepo.GetPrograms();
                var coursesLst = courseRepo.GetAll();
                List<string> corruptedFiles = new List<string>();
                for (int i = 0; i < files.Count; i++)
                {
                    try
                    {
                        var (name, ssn, seatNumber, studentCourses, studentPrograms, studentID, semesterCounter)
                        = AcademicReportReader.Read(files.ElementAt(i), studentRepo, academicYearsLst, programsLst, coursesLst);
                        if (string.IsNullOrEmpty(ssn) || string.IsNullOrEmpty(name) || seatNumber == 0)
                        {
                            corruptedFiles.Add(files[i].FileName);
                            continue;
                        }
                        var (toBeSavedLst, toBeRemovedLst, toBeUpdatedLst, toBeUpdatedOldMarksLst)
                        = studentCoursesRepo.CompareStudentCourse(studentID, studentCourses);
                        var toBeInserted = toBeSavedLst.Select(x => StudentCoursesModel.ToViewModel(x, academicYearsLst));
                        var toBeRemoved = toBeRemovedLst.Select(x => StudentCoursesModel.ToViewModel(x, academicYearsLst));
                        var toBeUpdated = toBeUpdatedOldMarksLst.Select(x => StudentCoursesUpdateModel.ToViewModel(x, toBeUpdatedLst, academicYearsLst));
                        var res = UpdateFromAcademicReport(new AcademicRecordModels
                        {
                            Name = name,
                            SSN = ssn,
                            SeatNumber = seatNumber,
                            NumberOfSemesters = semesterCounter,
                            StudentPrograms = studentPrograms,
                            ToBeInserted = toBeInserted.ToList(),
                            ToBeRemoved = toBeRemoved.ToList(),
                            ToBeUpdated = toBeUpdated.ToList()
                        });
                        if (res.GetType().Name.ToString() == "BadRequestObjectResult")
                            corruptedFiles.Add(files[i].FileName);
                    }
                    catch
                    {
                        corruptedFiles.Add(files[i].FileName);
                    }
                }
                return Ok(new
                {
                    FailedToInsert = corruptedFiles
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
                        Massage = Resource.ErrorOccurred,
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
                if (summary == null || !summary.Courses.Any()) return NotFound();
                var summaryTree = studentRepo.GetStudentCoursesSummaryTree(student.Id);
                var reEnteredCourses = studentRepo.GetStudentReEnteredCourses(student.Id);
                var stream = StudentCoursesSummaryReport.CreateCoursesSummarySheet(summary, summaryTree, reEnteredCourses);
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
                if (students == null || students.Count < 1)
                    return NotFound(new
                    {
                        Massage = Resource.NoData
                    });
                var stream = StruggledStudentsReport.Create(students, model.WarningsNumber);
                return File(stream,
                    "application/vnd.ms-excel",
                    "StruggledStudents_" + DateTime.UtcNow.AddHours(Helper.GetUtcOffset()).ToString() + ".xlsx");
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
                    new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var res = studentRepo.GetAcademicDetailsForReport(student.Id);
                var bytes = StudentAcademicReportPDF.CreateAcademicReport(res);
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
        [HttpGet("GetAcademicReportExcel/{guid}")]
        public IActionResult GetAcademicReportExcel(string guid)
        {
            try
            {
                Student student = studentRepo.Get(guid, true);
                if (student == null)
                    return NotFound(
                    new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                var res = studentRepo.GetAcademicDetailsForReport(student.Id);
                var stream = AcademicReportReader.Create(res);
                return File(stream,
                    "application/vnd.ms-excel",
                    student.Name + "_" + DateTime.UtcNow.AddHours(Helper.GetUtcOffset()).ToString() + ".xlsx");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("ExcelAcademicReportsPerProgram/{ProgramGuid}")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult GetAcademicReportExcels(string ProgramGuid)
        {
            try
            {
                var program = programRepo.GetProgram(this.ProgramID(), ProgramGuid);
                if (program == null)
                    return NotFound();
                var models = studentRepo.AcademicReportsPerProgram(program.Guid);
                var (fileContent, fileName) = AcademicReportReader.CreateMultiple(program.Name, models);
                return File(fileContent, "application/zip", fileName + ".zip");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
