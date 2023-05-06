using ClosedXML.Excel;
using FOS.App.ExcelReader;
using FOS.App.Helpers;
using FOS.App.PDFCreators;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.Doctors.API.Extenstions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class CourseController : ControllerBase
    {
        private readonly ILogger<CourseController> logger;
        private readonly ICourseRepo courseRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IDoctorRepo doctorRepo;
        private readonly IDateRepo dateRepo;

        public CourseController(ILogger<CourseController> logger
            , ICourseRepo courseRepo
            , IStudentCoursesRepo studentCoursesRepo
            , IAcademicYearRepo academicYearRepo
            , IDoctorRepo doctorRepo
            , IDateRepo dateRepo)
        {
            this.logger = logger;
            this.courseRepo = courseRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.academicYearRepo = academicYearRepo;
            this.doctorRepo = doctorRepo;
            this.dateRepo = dateRepo;
        }
        [HttpPost("GetAll")]
        public IActionResult GetAll([FromBody] SearchCriteria criteria)
        {
            try
            {
                string doctorID = null;
                if (criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "mycourses")?.Value?.ToString().ToLower() == "true")
                    doctorID = doctorRepo.GetById(this.Guid()).Guid;

                var courses = courseRepo.GetAll(out int totalCount, doctorID, criteria, this.ProgramID());
                return Ok(new
                {
                    Courses = courses,
                    TotalCount = totalCount
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpGet("GetByID/{id}")]
        public IActionResult GetByID(string id)
        {
            try
            {
                var course = courseRepo.GetById(id);
                if (course == null)
                    return NotFound();
                var (courseData, doctors, programs) = courseRepo.GetCourseDetails(course.Id);
                return Ok(new
                {
                    Course = courseData,
                    Doctors = doctors,
                    Programs = programs
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("Add")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult AddCourse(AddCourseParamModel course)
        {
            try
            {
                if (courseRepo.IsCourseExist(course.CourseCode))
                    return BadRequest(new
                    {
                        Massage = Resource.CourseAlreadyExist
                    });
                if (!Helper.IsValidCourseData(course))
                    return BadRequest(new
                    {
                        Massage = Resource.InvalidData
                    });
                var savedCourses = courseRepo.Add(course);
                if (!savedCourses)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = course
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpDelete("Delete/{id}")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult DeleteCourse(string id)
        {
            try
            {
                var course = courseRepo.GetById(id);
                if (course == null)
                    return NotFound();
                var res = courseRepo.Delete(id);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = id
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPut("Update/{id}")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult UpdateCourse(string id, AddCourseParamModel courseModel)
        {
            try
            {
                var course = courseRepo.GetById(id);
                if (course == null)
                    return NotFound();
                if (courseRepo.IsCourseExist(courseModel.CourseCode)
                    && course.CourseCode != courseModel.CourseCode)
                    return BadRequest(new
                    {
                        Massage = Resource.CourseAlreadyExist
                    });
                if (!Helper.IsValidCourseData(courseModel))
                    return BadRequest(new
                    {
                        Massage = Resource.InvalidData
                    });
                bool res = courseRepo.Update(course.Id, courseModel);
                if (!res) return BadRequest(new
                {
                    Massage = Resource.ErrorOccurred,
                    Data = courseModel
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
        public IActionResult Activate([FromBody] HashSet<string> courseIDs)
        {
            try
            {
                if (courseIDs == null || courseIDs.Count < 1 || (courseIDs.Count == 1 && courseIDs.ElementAt(0) == "string"))
                    return BadRequest(new
                    {
                        Massage = Resource.EmptyList,
                        Data = courseIDs
                    });
                var activated = courseRepo.ToggleActivation(courseIDs, true);
                if (!activated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = courseIDs
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("Deactivate")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult Deactivate([FromBody] HashSet<string> courseIDs)
        {
            try
            {
                if (courseIDs == null || courseIDs.Count < 1 || (courseIDs.Count == 1 && courseIDs.ElementAt(0) == "string"))
                    return BadRequest(new
                    {
                        Massage = Resource.EmptyList,
                        Data = courseIDs
                    });
                var deActivated = courseRepo.ToggleActivation(courseIDs, false);
                if (!deActivated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = courseIDs
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("CreateGradesSheet/{CourseID}/{IsFinalExam}")]
        public IActionResult CreateGradesExcel(string CourseID, bool IsFinalExam)
        {
            try
            {
                var course = courseRepo.GetById(CourseID);
                if (course == null)
                    return NotFound();
                if ((IsFinalExam && !course.HasFinalExam())
                   || (!IsFinalExam && !course.HasYearWorkExams()))
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.CourseDoesntHaveThisMarkType)
                    });
                var data = studentCoursesRepo.GetStudentsMarksList(new StudentsExamParamModel { CourseID = course.Id });
                if (data.Course == null) return NotFound();
                if (data.Students == null || data.Students.Count < 1)
                    return NotFound(new
                    {
                        Massage = Resource.NoData
                    });
                var stream = CourseGradesSheet.CreateSheet(data, IsFinalExam);
                return File(stream,
                    "application/vnd.ms-excel",
                    string.Concat(data.Course.CourseCode, "_", data.Course.CourseName,
                        "_", Helper.GetDescription(IsFinalExam ? ExamTypeEnum.Final : ExamTypeEnum.YearWork), ".xlsx")
                    );
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("UploadGradesSheet")]
        public IActionResult UploadGradesSheet([FromForm] StudentExamSheetUploadParamModel model)
        {
            try
            {
                if ((model.IsFinalExam && !dateRepo.IsInRegisrationInterval((int)DateForEnum.UploadFinalGradesSheets))
                    || (!model.IsFinalExam && !dateRepo.IsInRegisrationInterval((int)DateForEnum.UploadYearWorkGradesSheets)))
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.NotAvailable,
                        model.IsFinalExam ? Resource.UploadFinalGradesSheets : Resource.UploadYearWorkGradesSheets)
                    });
                if (model.file.Length < 0 || !model.file.FileName.EndsWith(".xlsx"))
                    return BadRequest(new
                    {
                        Massage = Resource.FileNotValid
                    });
                var course = courseRepo.GetById(model.CourseID);
                if (course == null)
                    return NotFound();
                if ((model.IsFinalExam && !course.HasFinalExam())
                    || (!model.IsFinalExam && !course.HasYearWorkExams()))
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.CourseDoesntHaveThisMarkType)
                    });
                MemoryStream ms = new MemoryStream();
                model.file.OpenReadStream().CopyTo(ms);
                var wb = new XLWorkbook(ms);
                ms.Close();
                wb.TryGetWorksheet(wb.Worksheets.ElementAt(0).Name, out var ws);
                var H2Text = ws.Cell("H2").Value.ToString();
                var courseCode = H2Text.Split("\n")[1].Trim();
                courseCode = courseCode.Substring(1, courseCode.Length - 2);
                if (ws == null || courseCode != course.CourseCode)
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.FileNotValid,
                                                courseCode,
                                                course.CourseCode)
                    });
                var splitedH2 = H2Text.Split(':');
                var examType = splitedH2[^1].Split("\n")[0].Trim();
                if ((examType == Helper.GetDescription(ExamTypeEnum.Final) && !model.IsFinalExam) ||
                    (examType == Helper.GetDescription(ExamTypeEnum.YearWork) && model.IsFinalExam))
                    return BadRequest(new
                    {
                        Massage = Resource.FileNotValid
                    });
                var outModel = CourseGradesSheet.ReadGradesSheet(wb, academicYearRepo.GetCurrentYear().Id, course.Id, model.IsFinalExam);
                if (outModel == null)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred
                    });
                var updated = studentCoursesRepo.UpdateStudentsGradesFromSheet(outModel, model.IsFinalExam);
                if (!updated)
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
        [HttpGet("GetAllGradesSheet/{IsFinalExam}")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult GetAllGradesSheet(bool IsFinalExam)
        {
            try
            {
                var data = studentCoursesRepo.GetStudentsMarksList(IsFinalExam);
                var (fileContent, fileName) =
                    CourseGradesSheet.CreateMultipleSheets(data, IsFinalExam);
                return File(fileContent, "application/zip", fileName + ".zip");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("UploadMultipleGradesSheet")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult UploadMultipleGradesSheet([FromForm] MultipleCourseExamSheetUploadModel model)
        {
            try
            {
                if (model == null || model.Files.Count < 1 || !model.Files.TrueForAll(x => x.FileName.EndsWith(".xlsx")))
                    return BadRequest(new
                    {
                        Massage = Resource.FileNotValid
                    });
                var (outModel, errors) = CourseGradesSheet.ReadMultipleGradesSheet(model, academicYearRepo.GetCurrentYear().Id, courseRepo.GetAll());
                if (outModel.Count > 0)
                {
                    var updated = studentCoursesRepo.UpdateStudentsGradesFromSheet(outModel, model.IsFinalExam);
                    if (!updated)
                        return BadRequest(new
                        {
                            Massage = Resource.ErrorOccurred
                        });
                }
                return Ok(new
                {
                    FilesWithError = errors
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpGet("CreateCommitteePDF/{CourseID}/{ExamType}")]
        public IActionResult CreateCommitteePDF(string CourseID, int ExamType)
        {
            try
            {
                if (!(ExamType >= 1 && ExamType <= 4))
                    return BadRequest(new { Massage = Resource.InvalidData });
                var course = courseRepo.GetById(CourseID);
                if (course == null)
                    return NotFound();
                if (!Helper.HasThisTypeOfExam(ExamType, course))
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.CourseDoesntHaveThisMarkType, Helper.GetDisplayName((ExamTypeEnum)ExamType))
                    });
                var result = studentCoursesRepo.GetStudentsList(course.Id);
                if (result.Students.Count < 1)
                    return NotFound(new
                    {
                        Massage = Resource.NoData
                    });
                var bytes = ExamCommitteesReport.CreateCommittePDFAsByteArray(result,
                    Helper.GetDescription((ExamTypeEnum)ExamType));
                return File(bytes,
                    "application/pdf",
                    string.Concat(result.Course.CourseCode, "_", result.Course.CourseName, "_Committees", ".pdf")
                    );
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("CreateAllCommittePDFsForFinal")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult CreateAllCommittePDFsForFinal()
        {
            try
            {
                var studentsListsModel = studentCoursesRepo.GetStudentsLists();
                if (studentsListsModel == null || !studentsListsModel.Any())
                    return NoContent();
                var (fileContent, fileName) =
                    ExamCommitteesReport.CreateExamCommitteesPdf(studentsListsModel);
                return File(fileContent, "application/zip", fileName + ".zip");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("AssignDoctorsToCourse")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult AssignDoctorsToCourse(DoctorsToCourseParamModel model)
        {
            try
            {
                if (model.DoctorsGuid == null ||
                    model.DoctorsGuid.Count < 1 ||
                    model.DoctorsGuid.Any(x => string.IsNullOrEmpty(x)))
                    return BadRequest(new
                    {
                        Massage = Resource.InvalidID,
                        Data = model
                    });
                bool assigned = courseRepo.AssignDoctorsToCourse(model);
                if (!assigned) return BadRequest(new
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
        [HttpPost("ConfirmExamsResult")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult ConfirmExamsResult()
        {
            try
            {
                var confirmed = courseRepo.ConfirmExamsResult();
                if (!confirmed)
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
    }
}
