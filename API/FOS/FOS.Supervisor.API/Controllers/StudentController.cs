using FOS.App.Student.Mappers;
using FOS.App.Supervisor.DTOs;
using FOS.App.Supervisor.Mappers;
using FOS.Core.IRepositories.Supervisor;
using FOS.Core.SearchModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Supervisor.API.Controllers
{
    public class StudentController : ExtensionController
    {
        private readonly IStudentRepo studentRepo;

        public StudentController(IStudentRepo studentRepo)
        {
            this.studentRepo = studentRepo;
        }
        [Authorize]
        [HttpPost("GetStudentsWithWarnings")]
        public IActionResult GetStudentsWithWarnings([FromBody] SearchCriteria criteria)
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

        [Authorize]
        [HttpPost("GetStudents")]
        public IActionResult GetStudents([FromBody] SearchCriteria criteria)
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

        [Authorize]
        [HttpGet("GetAcademicDetails/{guid}")]
        [ProducesResponseType(200,Type =typeof(StudentAcademicReportDTO))]
        public IActionResult GetAcademicDetails(string guid)
        {
            var studentCourses = studentRepo.GetAcademicDetails(guid);
            var studentPrograms = studentRepo.GetPrograms(guid);
            var academicYears = studentCourses.Select(x => x.AcademicYear).Distinct().OrderBy(x => x.Id).ToList();
            List<AcademicYearDTO> academicYearsDTO = new List<AcademicYearDTO>();
            for (int i = 0; i < academicYears.Count; i++)
            {
                var courses = studentCourses.Where(x => x.AcademicYearId == academicYears.ElementAt(i).Id).ToList().ToDTO();
                decimal? cGpa = i == 0 ? 0 : academicYearsDTO.ElementAt(i - 1).CGPA;
                int? cHours = i == 0 ? 0 : academicYearsDTO.ElementAt(i - 1).CHours;
                string? programName;
                var prog = studentPrograms.FirstOrDefault(x => x.AcademicYear == academicYears.ElementAt(i).Id);
                if (prog == null)
                    programName = academicYearsDTO.LastOrDefault()?.ProgramName;
                else
                    programName = studentPrograms.FirstOrDefault(p => p.ProgramId == prog.ProgramId)?.Program?.Name;
                var acaDTO = academicYears.ElementAt(i)
                    .ToDTO(programName, courses, cGpa, cHours, i == academicYears.Count - 1);
                academicYearsDTO.Add(acaDTO);
            }
            DB.Models.Student student = studentRepo.Get(guid);
            string? progName = studentPrograms.Count > 0 ? studentPrograms?.ElementAt(studentPrograms.Count - 1).Program.Name : "";
            StudentAcademicReportDTO? studentReport =
                        student?.ToDTO(academicYearsDTO, progName);
            studentReport = studentReport == null ? new StudentAcademicReportDTO() : studentReport;
            return Ok(studentReport);
        }
    }
}
