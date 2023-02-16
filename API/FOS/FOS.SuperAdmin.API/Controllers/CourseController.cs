using ClosedXML.Excel;
using FOS.App.Doctor.DTOs;
using FOS.App.Doctor.Mappers;
using FOS.Core.IRepositories;
using FOS.Core.Models;
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

                var wb = new XLWorkbook();
                wb.Author = "Science 2023";
                var ws = wb.Worksheets.Add(course.CourseCode);
                ws.SetRightToLeft();
                var studentsList = studentCoursesRepo.GetStudentsList(course.Id, academicYearRepo.GetCurrentYear().Id);
                var stdsCount = studentsList.Count;
                
                ws.Cell("A1").Value = "الكود الاكاديمى";
                ws.Cell("B1").Value = "الاسم";
                ws.Cell("C1").Value = "المستوى";
                ws.Cell("D1").Value = "الدرجة";
                for (int i = 0; i < stdsCount; i++)
                {
                    var student = studentsList.ElementAt(i).Student;
                    ws.Cell("A" + (i + 2)).Value = student.AcademicCode;
                    ws.Cell("B" + (i + 2)).Value = student.Name;
                    ws.Cell("C" + (i + 2)).Value = student.Level;
                    ws.Cell("D" + (i + 2)).Value = studentsList.ElementAt(i).Mark;
                }

                var range = ws.Range(1, 1, studentsList.Count + 1, 4);
                var table = range.CreateTable();
                table.Theme = XLTableTheme.TableStyleMedium16;
                table.Style.Font.FontSize = 14;
                table.Style.Font.FontName = "Calibri";
                table.HeadersRow().Style.Font.Bold = true;
                table.HeadersRow().Style.Font.FontSize = 16;
                table.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                table.Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
                ws.Range(1, 1, ws.LastRow().RangeAddress.RowSpan, ws.LastColumn().RangeAddress.ColumnSpan).Style.Protection.SetLocked(true);
                ws.Range("D2:D"+(stdsCount +1)).Style.Protection.SetLocked(false);
                ws.Range("D2:D"+stdsCount+1).CreateDataValidation().WholeNumber.Between(0, (course.CreditHours * 50));
                ws.Protect("54321", XLProtectionAlgorithm.Algorithm.SHA512,
                    XLSheetProtectionElements.SelectUnlockedCells
                    | XLSheetProtectionElements.AutoFilter
                    | XLSheetProtectionElements.SelectLockedCells
                    | XLSheetProtectionElements.Sort
                    );
                ws.Columns().AdjustToContents();
                var stream = new MemoryStream();
                wb.SaveAs(stream);
                stream.Seek(0, SeekOrigin.Begin);
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
                int rowsCount = ws.Rows().Count();
                List<GradesSheetUpdateModel> model = new List<GradesSheetUpdateModel>();
                var yearID = academicYearRepo.GetCurrentYear().Id;
                for (int i = 2; i <= rowsCount; i++)
                {
                    byte? mark = null;
                    if (ws.Cell("D" + i).Value.ToString().Trim().Length > 0)
                        mark = byte.Parse(ws.Cell("D" + i).Value.ToString());
                    var academicCode = ws.Cell("A" + i).Value.ToString();
                    if (!string.IsNullOrEmpty(academicCode))
                        model.Add(new GradesSheetUpdateModel
                        {
                            CourseID = courseID,
                            AcademicYearID = yearID,
                            Mark = mark,
                            AcademicCode = academicCode
                        });
                }
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
