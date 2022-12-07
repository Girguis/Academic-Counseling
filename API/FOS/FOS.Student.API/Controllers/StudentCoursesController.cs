using FOS.App.Student.DTOs;
using FOS.App.Student.Mappers;
using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Controllers
{
    public class StudentCoursesController : ExtensionController
    {
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IStudentRepo studentRepo;

        public StudentCoursesController(IAcademicYearRepo academicYearRepo,
                                        IStudentCoursesRepo studentCoursesRepo,
                                        IStudentRepo studentRepo)
        {
            this.academicYearRepo = academicYearRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.studentRepo = studentRepo;
        }
        [Authorize]
        [HttpGet("GetAcademicYearsSummary")]
        [ProducesResponseType(200,Type=typeof(List<AcademicYearsDTO>))]
        public IActionResult GetAcademicYearsSummary()
        {
            string? guid = GetGuid();
            if (string.IsNullOrEmpty(guid))
                return BadRequest("Invalid Student ID");
            DB.Models.Student student = studentRepo.Get(guid);
            if (student == null)
                return BadRequest("Student Not Found");
            List<AcademicYear> academicYears = academicYearRepo.GetAll(student.Id);
            List<AcademicYearsDTO> academicYearsDTO = new List<AcademicYearsDTO>();
            for (int i = 0; i < academicYears.Count; i++)
            {
                double? sgpa = academicYearRepo.GetAcademicYearGPA(student.Id, academicYears.ElementAt(i).Id);
                sgpa = sgpa != null ? Math.Round(sgpa.Value, 4) : sgpa;
                academicYearsDTO.Add(academicYears.ElementAt(i).ToDTO(sgpa));
            }
            return Ok(academicYearsDTO);
        }

        [Authorize]
        [HttpGet("GetAcademicYearDetails")]
        [ProducesResponseType(200,Type =typeof(List<StudentCoursesDTO>))]
        public IActionResult GetAcademicYearDetails(short academicYearID)
        {
            string? guid = GetGuid();
            if (string.IsNullOrEmpty(guid))
                return BadRequest("Invalid Student ID");

            DB.Models.Student student = studentRepo.Get(guid);
            if (student == null)
                return BadRequest("Student Not Found");

            List<StudentCourse> cources = studentCoursesRepo.GetCoursesByAcademicYear(student.Id, academicYearID);
            List<StudentCoursesDTO> courcesDTO = new List<StudentCoursesDTO>();
            for (int i = 0; i < cources.Count; i++)
                courcesDTO.Add(cources.ElementAt(i).ToDTO());

            return Ok(courcesDTO);
        }
    }
}
