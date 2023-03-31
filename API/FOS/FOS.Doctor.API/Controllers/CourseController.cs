using ClosedXML.Excel;
using FOS.App.ExcelReader;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;
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

        public CourseController(ILogger<CourseController> logger
            , ICourseRepo courseRepo
            , IStudentCoursesRepo studentCoursesRepo
            , IAcademicYearRepo academicYearRepo
            , IDoctorRepo doctorRepo)
        {
            this.logger = logger;
            this.courseRepo = courseRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.academicYearRepo = academicYearRepo;
            this.doctorRepo = doctorRepo;
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
        public IActionResult GetByID(int id)
        {
            try
            {
                var (course, doctors, programs) = courseRepo.GetCourseDetails(id);
                if (course == null)
                    return NotFound();
                return Ok(new
                {
                    Course = course,
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
                        Massage = Resource.ErrorOccured,
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
        public IActionResult DeleteCourse(int id)
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
                        Massage = Resource.ErrorOccured,
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
        public IActionResult UpdateCourse(int id, AddCourseParamModel courseModel)
        {
            try
            {
                var course = courseRepo.GetById(id);
                if (courseRepo.IsCourseExist(courseModel.CourseCode)
                    && course != null
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
                bool res = courseRepo.Update(id, courseModel);
                if (!res) return BadRequest(new
                {
                    Massage = Resource.ErrorOccured,
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
        public IActionResult Activate([FromBody] List<int> courseIDs)
        {
            try
            {
                if (courseIDs == null || courseIDs.Count < 1 || (courseIDs.Count == 1 && courseIDs[0] == 0))
                    return BadRequest(new
                    {
                        Massage = Resource.EmptyList,
                        Data = courseIDs
                    });
                var activated = courseRepo.Activate(courseIDs);
                if (!activated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
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
        public IActionResult Deactivate([FromBody] List<int> courseIDs)
        {
            try
            {
                if (courseIDs == null || courseIDs.Count < 1 || (courseIDs.Count == 1 && courseIDs[0] == 0))
                    return BadRequest(new
                    {
                        Massage = Resource.EmptyList,
                        Data = courseIDs
                    });
                var deActivated = courseRepo.Deactivate(courseIDs);
                if (!deActivated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
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
        [HttpGet("CreateGradesSheet")]
        [AllowAnonymous]
        public IActionResult CreateGradesExcel(StudentsExamParamModel model)
        {
            try
            {
                var course = courseRepo.GetById(model.CourseID);
                if (course == null)
                    return NotFound();
                if (!Helper.HasThisTypeOfExam(model.ExamType,course))
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.CourseDoesntHaveThisMarkType, Helper.GetDisplayName((ExamTypeEnum)model.ExamType))
                    });
                var data = studentCoursesRepo.GetStudentsMarksList(model);
                if (data.Course == null) return NotFound();
                var stream = CourseGradesSheet.CreateSheet(data, model.ExamType);
                return File(stream,
                    "application/vnd.ms-excel",
                    string.Concat(data.Course.CourseCode, "_", data.Course.CourseName,
                        "_", Helper.GetDescription((ExamTypeEnum)model.ExamType), ".xlsx")
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
                if (model.file.Length < 0 || !model.file.FileName.EndsWith(".xlsx"))
                    return BadRequest(new
                    {
                        Massage = Resource.FileNotValid,
                        Data = new
                        {
                            CourseID = model.CourseID,
                            File = model.file
                        }
                    });
                var course = courseRepo.GetById(model.CourseID);
                if (course == null)
                    return NotFound();
                if (!Helper.HasThisTypeOfExam(model.ExamType, course))
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.CourseDoesntHaveThisMarkType, Helper.GetDisplayName((ExamTypeEnum)model.ExamType))
                    });
                MemoryStream ms = new MemoryStream();
                model.file.OpenReadStream().CopyTo(ms);
                var wb = new XLWorkbook(ms);
                ms.Close();
                wb.TryGetWorksheet(course.CourseCode, out var ws);
                if (ws == null)
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.FileNotValid,
                                                wb.Worksheet(1).Name,
                                                course.CourseCode),
                        Data = new
                        {
                            CourseID = model.CourseID,
                            File = model.file
                        }
                    });
                var allText = ws.Cell("G2").Value.GetText().Split(':');
                var examType = allText[allText.Length - 1].Trim();
                var requestedExamType = Helper.GetDescription((ExamTypeEnum)model.ExamType);
                if (examType != requestedExamType)
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.FileNotValid,
                                                examType,
                                               requestedExamType),
                        Data = new
                        {
                            CourseID = model.CourseID,
                            File = model.file
                        }
                    });
                var outModel = CourseGradesSheet.ReadGradesSheet(ws, academicYearRepo.GetCurrentYear().Id, model.CourseID);
                if (outModel == null)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
                        Data = new
                        {
                            CourseID = model.CourseID,
                            File = model.file
                        }
                    });
                var updated = studentCoursesRepo.UpdateStudentsGradesFromSheet(outModel, model.ExamType);
                if (!updated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccured,
                        Data = new
                        {
                            CourseID = model.CourseID,
                            File = model.file
                        }
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("CreateCommitteePDF")]
        public IActionResult CreateCommitteePDF(StudentsExamParamModel model)
        {
            try
            {
                var result = studentCoursesRepo.GetStudentsList(model);
                if (result.Course == null) return NotFound();
                if (!Helper.HasThisTypeOfExam(model.ExamType, result.Course))
                    return BadRequest(new
                    {
                        Massage = string.Format(Resource.CourseDoesntHaveThisMarkType, Helper.GetDisplayName((ExamTypeEnum)model.ExamType))
                    });

                var bytes = ExamCommitteesReport.CreateExamCommitteesPdf(result,
                    Helper.GetDescription((ExamTypeEnum)model.ExamType));
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
        [HttpPost("AssignDoctorsToCourse")]
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
        [HttpPost("ConfirmExamsResult")]
        public IActionResult ConfirmExamsResult()
        {
            try
            {
                var confirmed = courseRepo.ConfirmExamsResult();
                if (!confirmed)
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
    }
}
