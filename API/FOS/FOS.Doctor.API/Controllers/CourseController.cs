using ClosedXML.Excel;
using FOS.App.ExcelReader;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
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
    public class CourseController : ControllerBase
    {
        private readonly ILogger<CourseController> logger;
        private readonly ICourseRepo courseRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IAcademicYearRepo academicYearRepo;

        public CourseController(ILogger<CourseController> logger
            , ICourseRepo courseRepo
            , IStudentCoursesRepo studentCoursesRepo
            , IAcademicYearRepo academicYearRepo)
        {
            this.logger = logger;
            this.courseRepo = courseRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.academicYearRepo = academicYearRepo;
        }
        [HttpPost("GetAll")]
        public IActionResult GetAll([FromBody] SearchCriteria criteria)
        {
            try
            {
                var courses = courseRepo.GetAll(out int totalCount, criteria, this.ProgramID());
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
                var courseData = courseRepo.GetCourseDetails(id);
                if (courseData.course == null)
                    return NotFound();
                return Ok(new
                {
                    Course = courseData.course,
                    Doctors = courseData.doctors,
                    Programs = courseData.programs
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("Add")]
        public IActionResult AddCourse(HashSet<CourseModel> models)
        {
            try
            {
                List<Course> courses = new();
                for (int i = 0; i < models.Count; i++)
                    courses.Add(models.ElementAt(i).ToDBCourseModel());

                var savedCourses = courseRepo.Add(courses);
                if (!savedCourses)
                    return BadRequest(new
                    {
                        Massage = "Error Occured while adding course",
                        Data = models
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
                var res = courseRepo.Delete(course);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error Occured while deleting course",
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
        public IActionResult UpdateCourse(int id, CourseModel courseModel)
        {
            try
            {
                Course course = courseModel.ToDBCourseModel(id);
                bool res = courseRepo.Update(course);
                if (!res) return BadRequest(new
                {
                    Massage = "Error Occured while updating course",
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
                        Massage = "List can't be empty",
                        Data = courseIDs
                    });
                var activated = courseRepo.Activate(courseIDs);
                if (!activated)
                    return BadRequest(new
                    {
                        Massage = "Error occured while activating courses",
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
                        Massage = "List can't be empty",
                        Data = courseIDs
                    });
                var activated = courseRepo.Deactivate(courseIDs);
                if (!activated)
                    return BadRequest(new
                    {
                        Massage = "Error occured while deactivating courses",
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
        [HttpGet("CreateGradesSheet/{courseID}")]
        public IActionResult CreateGradesExcel(int courseID)
        {
            try
            {
                var data = studentCoursesRepo.GetStudentsMarksList(courseID);
                if (data.Course == null) return NotFound();
                var stream = CourseGradesSheet.CreateSheet(data);
                return File(stream,
                    "application/vnd.ms-excel",
                    string.Concat(data.Course.CourseCode, "_", data.Course.CourseName, "_GradesSheet", ".xlsx")
                    );
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("UploadGradesSheet/{courseID}")]
        public IActionResult UploadGradesSheet(int courseID, IFormFile file)
        {
            try
            {
                if (file.Length < 0 || !file.FileName.EndsWith(".xlsx"))
                    return BadRequest(new
                    {
                        Massage = "File is not valid",
                        Data = new
                        {
                            CourseID = courseID,
                            File = file
                        }
                    });
                var course = courseRepo.GetById(courseID);
                if (course == null)
                    return NotFound();
                MemoryStream ms = new MemoryStream();
                file.OpenReadStream().CopyTo(ms);
                var wb = new XLWorkbook(ms);
                ms.Close();
                wb.TryGetWorksheet(course.CourseCode, out var ws);
                if (ws == null)
                    return BadRequest(new
                    {
                        Massage = string.Concat("uploaded sheet is for ",
                                                wb.Worksheet(1).Name,
                                                " while requested course is for ",
                                                course.CourseCode),
                        Data = new
                        {
                            CourseID = courseID,
                            File = file
                        }
                    });
                var model = CourseGradesSheet.ReadGradesSheet(ws, academicYearRepo.GetCurrentYear().Id, courseID);
                var updated = studentCoursesRepo.UpdateStudentsGradesFromSheet(model);
                if (!updated)
                    return BadRequest(new
                    {
                        Massage = "Error occured while updating marks",
                        Data = new
                        {
                            CourseID = courseID,
                            File = file
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
        public IActionResult CreateCommitteePDF(ExamCommitteeStudentsParamModel model)
        {
            try
            {
                var result = studentCoursesRepo.GetStudentsList(model);
                if (result.Course == null) return NotFound();
                var bytes = ExamCommitteesReport.CreateExamCommitteesPdf(result,
                    Helper.GetEnumDescription((ExamTypeEnum)model.ExamType));
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
                if (model.DoctorsGuid == null || model.DoctorsGuid.Count < 1 || model.DoctorsGuid.Any(x => string.IsNullOrEmpty(x)))
                    return BadRequest(new
                    {
                        Massage = "Invalid Doctors guid",
                        Data = model
                    });
                bool assigned = courseRepo.AssignDoctorsToCourse(model);
                if (!assigned) return BadRequest(new
                {
                    Massage = "Error occured while assigning doctors to course",
                    Data = model
                });
                return Ok();
            }
            catch(Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
