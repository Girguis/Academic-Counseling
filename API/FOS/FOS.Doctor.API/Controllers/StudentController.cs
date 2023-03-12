using ClosedXML.Excel;
using FOS.App.Doctors.DTOs;
using FOS.App.Doctors.Mappers;
using FOS.App.ExcelReader;
using FOS.App.Helpers;
using FOS.App.Students.Mappers;
using FOS.Core.IRepositories;
using FOS.Core.Models;
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
        private readonly IDoctorRepo doctorRepo;

        public StudentController(IStudentRepo studentRepo,
            ILogger<StudentController> logger,
            IAcademicYearRepo academicYearRepo,
            IProgramRepo programRepo,
            ICourseRepo courseRepo,
            IStudentProgramRepo studentProgramRepo,
            IStudentCoursesRepo studentCoursesRepo,
            IDoctorRepo doctorRepo)
        {
            this.studentRepo = studentRepo;
            this.logger = logger;
            this.academicYearRepo = academicYearRepo;
            this.programRepo = programRepo;
            this.courseRepo = courseRepo;
            this.studentProgramRepo = studentProgramRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.doctorRepo = doctorRepo;
        }
        [HttpPost("Deactivate")]
        public IActionResult Deactivate([FromBody] GuidModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.Guid)) return NoContent();
                var res = studentRepo.Deactivate(model.Guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error Occured While Deactivating student account",
                        Data = model.Guid
                    });
                return Ok();
            }
            catch(Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("Activate")]
        public IActionResult Activate([FromBody]GuidModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.Guid)) return NoContent();
                var res = studentRepo.Activate(model.Guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error Occured While Deactivating student account",
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
            catch(Exception ex)
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
                StudentAcademicReportDTO? studentReport =
                            student?.ToDTO(academicYearsDTO);
                studentReport = studentReport == null ? new StudentAcademicReportDTO() : studentReport;
                return Ok(studentReport);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("ReadAcademicReport")]
        public IActionResult ReadAcademicReport(IFormFile file)
        {
            try
            {
                if (file.Length < 1 || !file.FileName.EndsWith(".xlsx"))
                {
                    return BadRequest();
                }
                var academicYearsLst = academicYearRepo.GetAcademicYearsList();
                var programsLst = programRepo.GetPrograms();
                var coursesLst = courseRepo.GetAll();
                var sheet = AcademicReportReader.Read(file, studentRepo, academicYearsLst, programsLst, coursesLst);
                var courses = studentCoursesRepo.CompareStudentCourse(sheet.Item6, sheet.Item4);
                var toBeInserted = courses.Item1.Select(x => StudentCoursesModel.ToViewModel(x, academicYearsLst));
                var toBeRemoved = courses.Item2.Select(x => StudentCoursesModel.ToViewModel(x, academicYearsLst));
                var toBeUpdated = courses.Item4.Select(x => StudentCoursesUpdateModel.ToViewModel(x, courses.Item3, academicYearsLst));
                return Ok(new AcademicRecordModels
                {
                    Name = sheet.Item1,
                    SSN = sheet.Item2,
                    SeatNumber = sheet.Item3,
                    StudentPrograms = sheet.Item5,
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
                        Ssn = model.SSN
                    }.ToDbModel();
                    student = studentRepo.Add(student);
                }
                for (int i = 0; i < model.StudentPrograms.Count; i++)
                    model.StudentPrograms.ElementAt(i).StudentId = student.Id;
                var addPrograms = studentProgramRepo.AddStudentPrograms(model.StudentPrograms);
                if (!addPrograms)
                {
                    return BadRequest(new
                    {
                        Massage = "Error happend while adding programs for student",
                        Data = model
                    });
                }
                var addCourses = studentCoursesRepo.UpdateStudentCourses(student.Id, model);
                if (!addCourses)
                    return BadRequest(new
                    {
                        Massage = "Error occured while updating courses data",
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
        [HttpPost("ChangePassword/{guid}")]
        public IActionResult ChangePassword(string guid, ChangePasswordModel model)
        {
            try
            {
                var student = studentRepo.Get(guid);
                if (student == null) return NotFound();
                student.Password = Helper.HashPassowrd(model.Password);
                var updated = studentRepo.Update(student);
                if (!updated)
                    return BadRequest(new
                    {
                        Massage = "Error Happend while updating password",
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
    }
}
