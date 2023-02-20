using ClosedXML.Excel;
using FOS.App.Doctor.DTOs;
using FOS.App.Doctor.Mappers;
using FOS.App.Helpers;
using FOS.App.Student.Mappers;
using FOS.Core.Enums;
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
    public class StudentController : ControllerBase
    {
        private readonly IStudentRepo studentRepo;
        private readonly ILogger<StudentController> logger;
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IProgramRepo programRepo;
        private readonly ICourseRepo courseRepo;
        private readonly IStudentProgramRepo studentProgramRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;

        public StudentController(IStudentRepo studentRepo,
            ILogger<StudentController> logger,
            IAcademicYearRepo academicYearRepo,
            IProgramRepo programRepo,
            ICourseRepo courseRepo,
            IStudentProgramRepo studentProgramRepo,
            IStudentCoursesRepo studentCoursesRepo)
        {
            this.studentRepo = studentRepo;
            this.logger = logger;
            this.academicYearRepo = academicYearRepo;
            this.programRepo = programRepo;
            this.courseRepo = courseRepo;
            this.studentProgramRepo = studentProgramRepo;
            this.studentCoursesRepo = studentCoursesRepo;
        }

        /// <summary>
        /// Get students with 1 or more warning by using studentRepo.GetStudentsWithWarnings
        /// After getting the list of students, it will be mapped to StudentWarningsDTO model
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns>list of students who have 1 or more warning and their total count</returns>
        [HttpPost("GetStudentsWithWarnings")]
        public IActionResult GetStudentsWithWarnings([FromBody] SearchCriteria criteria)
        {
            try
            {
                List<Student> students = studentRepo.GetStudentsWithWarnings(out int totalCount, criteria);
                List<StudentWarningsDTO> mappedStudents = new List<StudentWarningsDTO>();
                for (int i = 0; i < students.Count; i++)
                {
                    mappedStudents.Add(students.ElementAt(i).ToDTO());
                }
                return Ok(new
                {
                    Data = mappedStudents,
                    TotalCount = totalCount
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        /// <summary>
        /// Get all students with or without warning by using studentRepo.GetAll
        /// After getting the list of students, it will be mapped to StudentWarningsDTO model 
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns>List of mapped students and total count</returns>
        [HttpPost("GetStudents")]
        public IActionResult GetStudents([FromBody] SearchCriteria criteria)
        {
            try
            {
                List<Student> students = studentRepo.GetAll(out int totalCount, criteria);
                List<StudentWarningsDTO> mappedStudents = new List<StudentWarningsDTO>();
                for (int i = 0; i < students.Count; i++)
                {
                    mappedStudents.Add(students.ElementAt(i).ToDTO());
                }
                return Ok(new
                {
                    Data = mappedStudents,
                    TotalCount = totalCount
                });
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
                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new { Massage = "Student not found" });
                var studentCourses = studentRepo.GetAcademicDetails(guid);
                var studentPrograms = studentRepo.GetPrograms(guid);
                var academicYears = studentCourses.Select(x => x.AcademicYear).Distinct().OrderBy(x => x.Id).ToList();
                List<AcademicYearDTO> academicYearsDTO = new List<AcademicYearDTO>();
                for (int i = 0; i < academicYears.Count; i++)
                {
                    var academicYear = academicYears.ElementAt(i);
                    var courses = studentCourses.Where(x => x.AcademicYearId == academicYear.Id).ToList().ToDTO(academicYear.Id);
                    decimal? cGpa = i == 0 ? 0 : academicYearsDTO.ElementAt(i - 1).CGPA;
                    int? cHours = i == 0 ? 0 : academicYearsDTO.ElementAt(i - 1).CHours;
                    string? programName;
                    var prog = studentPrograms.FirstOrDefault(x => x.AcademicYear == academicYear.Id);
                    if (prog == null)
                        programName = academicYearsDTO.LastOrDefault()?.ProgramName;
                    else
                        programName = studentPrograms.FirstOrDefault(p => p.ProgramId == prog.ProgramId)?.Program?.Name;
                    var acaDTO = academicYear
                        .ToDTO(programName, courses, cGpa, cHours, i == academicYears.Count - 1);
                    academicYearsDTO.Add(acaDTO);
                }
                academicYearsDTO.Reverse();
                string? progName = studentPrograms.Count > 0 ? studentPrograms?.ElementAt(studentPrograms.Count - 1).Program.Name : "";
                StudentAcademicReportDTO? studentReport =
                            student?.ToDTO(academicYearsDTO, progName);
                studentReport = studentReport == null ? new StudentAcademicReportDTO() : studentReport;
                return Ok(studentReport);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("AddFromExcel")]
        public IActionResult AddFromExcel(List<IFormFile> files)
        {
            try
            {
                if (!files.TrueForAll(x => x.Length > 1 && x.FileName.EndsWith(".xlsx")) || files.Count <1)
                {
                    return BadRequest();
                }
                var academicYearsLst = academicYearRepo.GetAcademicYearsList();
                var programsLst = programRepo.GetPrograms();
                var coursesLst = courseRepo.GetAll();
                List<List<StudentCourse>> studentCourses = new List<List<StudentCourse>>();
                List<List<StudentProgram>> studentPrograms = new List<List<StudentProgram>>();
                Parallel.For(0, files.Count(), index =>
                {
                    MemoryStream ms = new MemoryStream();
                    files.ElementAt(index).OpenReadStream().CopyTo(ms);
                    var wb = new XLWorkbook(ms);
                    ms.Close();
                    var ws = wb.Worksheet(1);
                    int rowsCount = ws.Rows().Count();
                    var student = new StudentBasicModel();
                    student.Name = ws.Cell("Q9").Value.ToString();
                    student.Ssn = ws.Cell("E12").Value.ToString();
                    student.SeatNumber = ws.Cell("E9").Value.ToString();
                    var std = studentRepo.GetBySSN(student.Ssn);
                    if (std == null)
                    {
                        std = student.ToDbModel();
                        std = studentRepo.Add(std);
                    }
                    int studentID = std.Id;
                    short currentYearID = 1;
                    int currentProgramID;
                    int semesterCounter = 0;
                    string currentAcademicYearStr = "";
                    var subStudentCourses = new List<StudentCourse>();
                    var subStudentPrograms = new List<StudentProgram>();
                    for (int i = 21; i <= rowsCount; i++)
                    {
                        if (!ws.Cell("C" + i).IsEmpty()
                            && ws.Cell("C" + i).Value.ToString().Trim().Length > 1
                            && ws.Cell("U" + i).IsEmpty())
                        {
                            string cellVal = ws.Cell("C" + i).Value.ToString();
                            var cellValues = cellVal.Split('-');
                            int count = cellValues.Count();
                            if (count == 4)
                            {
                                currentAcademicYearStr = cellValues[1].Trim() + "/" + cellValues[2].Trim();
                                var ProgramNameStr = cellValues[3].Trim();
                                var semesterStr = ws.Cell("C" + (i + 2)).Value.ToString().Split('-')[0].Trim();
                                byte semesterNo = Helper.GetSemesterNumber(semesterStr);
                                if (semesterNo != (int)SemesterEnum.Summer)
                                    semesterCounter++;
                                currentYearID = academicYearsLst.FirstOrDefault(x => x.AcademicYear1 == currentAcademicYearStr && x.Semester == semesterNo).Id;
                                currentProgramID = programsLst.Where(x => x.ArabicName == ProgramNameStr && x.Semester <= semesterCounter)
                                                    .OrderByDescending(x => x.Semester).FirstOrDefault().Id;
                                if (!subStudentPrograms.Any(x => x.ProgramId == currentProgramID))
                                    subStudentPrograms.Add(new StudentProgram
                                    {
                                        StudentId = studentID,
                                        ProgramId = currentProgramID,
                                        AcademicYear = currentYearID
                                    });
                                i += 4;
                            }
                            else if (count == 2)
                            {
                                var semesterStr = ws.Cell("C" + i).Value.ToString().Split('-')[0].Trim();
                                var semesterNo = Helper.GetSemesterNumber(semesterStr);
                                if (semesterNo != (int)SemesterEnum.Summer)
                                    semesterCounter++;
                                currentYearID = academicYearsLst.FirstOrDefault(x => x.AcademicYear1 == currentAcademicYearStr && x.Semester == semesterNo).Id;
                                i += 2;
                            }
                        }
                        else if (!ws.Cell("U" + i).IsEmpty())
                        {
                            StudentCourse course = new StudentCourse();
                            course.StudentId = studentID;
                            course.AcademicYearId = currentYearID;
                            var courseCode = ws.Cell("U" + i).Value.ToString();
                            course.CourseId = coursesLst.FirstOrDefault(x => x.CourseCode == courseCode).Id;
                            if (ws.Cell("O" + i).IsEmpty())
                            {
                                course.HasExecuse = true;
                                course.Mark = null;
                                course.IsGpaincluded = false;
                            }
                            else
                            {
                                course.HasExecuse = false;
                                if (ws.Cell("S" + i).Value.ToString().Contains("-**"))
                                {
                                    course.IsGpaincluded = false;
                                    course.Grade = ws.Cell("R" + i).Value.ToString();
                                    course.Mark = null;
                                }
                                else if (ws.Cell("S" + i).Value.ToString().Contains("-"))
                                {
                                    course.IsGpaincluded = false;
                                    course.Grade = ws.Cell("R" + i).Value.ToString();
                                    course.Mark = byte.Parse(ws.Cell("O" + i).Value.ToString());
                                }
                                else
                                {
                                    course.IsGpaincluded = true;
                                    course.Mark = byte.Parse(ws.Cell("O" + i).Value.ToString());
                                }
                            }
                            course.IsApproved = true;
                            subStudentCourses.Add(course);
                        }
                    }
                    studentCourses.Add(subStudentCourses);
                    studentPrograms.Add(subStudentPrograms);
                });
                List<object> list = new List<object>();
                for (int i = 0; i < studentPrograms.Count; i++)
                {
                    var res = studentProgramRepo.AddStudentPrograms(studentPrograms[i]);
                    if (!res)
                        list.Add(new
                        {
                            Error = "Error happend while adding programs for student",
                            Data = studentPrograms[i]
                        });
                }
                for (int i = 0; i < studentCourses.Count; i++)
                {
                    var res = studentCoursesRepo.AddStudentCourses(studentCourses[i]);
                    if (!res)
                        list.Add(new
                        {
                            Error = "Error happend while adding courses for student",
                            Data = studentCourses[i]
                        });
                }
                if (list.Any())
                    return BadRequest(new
                    {
                        Errors = list
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
