using ClosedXML.Excel;
using FOS.App.Doctor.DTOs;
using FOS.App.Doctor.Mappers;
using FOS.App.ExcelReader;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using FOS.Doctor.API.Mappers;
using FOS.Doctor.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctor.API.Controllers
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
        private readonly ICoursePrerequisiteRepo coursePrerequisiteRepo;

        public CourseController(ILogger<CourseController> logger
            , ICoursePrerequisiteRepo coursePrerequisiteRepo
            , ICourseRepo courseRepo
            , IStudentCoursesRepo studentCoursesRepo
            , IAcademicYearRepo academicYearRepo)
        {
            this.logger = logger;
            this.courseRepo = courseRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.academicYearRepo = academicYearRepo;
            this.coursePrerequisiteRepo = coursePrerequisiteRepo;
        }
        [HttpPost("Get")]
        public IActionResult GetCourses([FromBody] SearchCriteria criteria)
        {
            try
            {
                var courses = courseRepo.GetAll(out int totalCount, criteria);
                var courseDTO = new List<CourseDTO>();
                for (int i = 0; i < courses.Count; i++)
                    courseDTO.Add(courses.ElementAt(i).ToDTO());
                return Ok(new
                {
                    Courses = courseDTO,
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
                var course = courseRepo.GetById(id);
                if (course == null)
                    return NotFound();
                var courseDTO = course.ToDTO();
                return Ok(new
                {
                    Data = courseDTO
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("Add")]
        public IActionResult AddCourse(List<CourseModel> models)
        {
            try
            {
                List<Course> courses = new List<Course>();
                for (int i = 0; i < models.Count; i++)
                    courses.Add(models.ElementAt(i).ToDBCourseModel());

                var savedCourses = courseRepo.Add(courses);
                if (savedCourses == false)
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
        [HttpPut("Update")]
        public IActionResult UpdateCourse(CourseModel courseModel)
        {
            try
            {
                Course course = courseModel.ToDBCourseModel();
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
        [HttpGet("CreateGradesSheet/{courseID}")]
        public IActionResult CreateGradesExcel(int courseID)
        {
            try
            {
                var course = courseRepo.GetById(courseID);
                if (course == null) return NotFound();
                var studentsList = studentCoursesRepo.GetStudentsList(course.Id, academicYearRepo.GetCurrentYear().Id);
                var stream = CourseGradesSheet.CreateSheet(studentsList, course);
                return File(stream,
                    "application/vnd.ms-excel",
                    string.Concat(course.CourseCode, "_", course.CourseName, "_GradesSheet", ".xlsx")
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
    }
}
