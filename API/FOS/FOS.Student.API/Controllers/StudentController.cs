using FOS.App.Doctors.Mappers;
using FOS.App.Helpers;
using FOS.App.Students.DTOs;
using FOS.App.Students.Mappers;
using FOS.Core.Configs;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
using FOS.DB.Models;
using FOS.Students.API.Extensions;
using FOS.Students.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace FOS.Students.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class StudentController : ControllerBase
    {
        private readonly IStudentRepo studentRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly ILogger logger;
        private readonly IConfiguration _configuration;
        public StudentController(IStudentRepo studentRepo
            , IConfiguration configuration
            , IStudentCoursesRepo studentCoursesRepo
            , IAcademicYearRepo academicYearRepo
            , ILogger<StudentController> logger)
        {
            this.studentRepo = studentRepo;
            _configuration = configuration;
            this.studentCoursesRepo = studentCoursesRepo;
            this.academicYearRepo = academicYearRepo;
            this.logger = logger;
        }

        [AllowAnonymous]
        [HttpPost("Login")]
        public IActionResult Login([FromBody] LoginModel loginModel)
        {
            try
            {
                string hashedPassword = Helper.HashPassowrd(loginModel.Password);
                //Get student by email & password
                var student = studentRepo.Login(loginModel.Email, hashedPassword);
                //If student object is null this mean either email or password is incorrect
                if (student != null)
                {
                    if (student.IsActive == false)
                        return Unauthorized(new
                        {
                            Message = Resource.InActiveAccount
                        });
                    //Generating access token
                    var stringToken = Helper.GenerateToken(new[]{
                        new Claim("Guid", student.Guid)
                    });
                    return Ok(new
                    {
                        Token = stringToken,
                    });
                }
                return Unauthorized(new
                {
                    Message = Resource.InvalidEmailOrPassword
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        /// <summary>
        /// Get GUID from access token and retrive student with that GUID
        /// after getting the student, get all registered courses for the current semester
        /// then map all these data to StudentDTO
        /// </summary>
        /// <returns>StudentDTO object which inculdes basic data and academic details for the current academic year</returns>
        [HttpGet("GetAcademicInfo")]
        [ProducesResponseType(200, Type = typeof(StudentDTO))]
        public IActionResult GetAcademicInfo()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new { Massage = Resource.InvalidID });

                Student student = studentRepo.Get(guid, true, true);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });

                var courses = studentCoursesRepo.GetCurrentAcademicYearCourses(student.Id);
                var mapedStudent = student.ToDTO(academicYearRepo.GetCurrentYear(), student.CurrentProgram?.Name);
                mapedStudent.Courses = courses;
                return Ok(new
                {
                    Data = mapedStudent
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("UpdatePassword")]
        public IActionResult UpdatePassword(ChangePasswordModel model)
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new
                    {
                        Massage = Resource.InvalidID
                    });

                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                student.Password = Helper.HashPassowrd(model.Password);
                var updated = studentRepo.Update(student);
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
        [HttpPost("MyRank")]
        public IActionResult MyRank()
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new
                    {
                        Massage = Resource.InvalidID
                    });

                Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Student)
                    });
                if (student.IsGraduated.HasValue && student.IsGraduated.Value == true)
                    return Ok(new RankModel{ Rank = null });
                return Ok(new RankModel { Rank = studentRepo.GetRank(student.Id, student.CurrentProgramId) });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
