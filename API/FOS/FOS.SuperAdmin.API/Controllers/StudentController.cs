using FOS.App.Doctor.DTOs;
using FOS.App.Student.Mappers;
using FOS.App.Doctor.Mappers;
using FOS.Core.SearchModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using FOS.Core.IRepositories;

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

        public StudentController(IStudentRepo studentRepo, ILogger<StudentController> logger)
        {
            this.studentRepo = studentRepo;
            this.logger = logger;
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
                List<DB.Models.Student> students = studentRepo.GetStudentsWithWarnings(out int totalCount, criteria);
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
                List<DB.Models.Student> students = studentRepo.GetAll(out int totalCount, criteria);
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
                DB.Models.Student student = studentRepo.Get(guid);
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
    }
}
