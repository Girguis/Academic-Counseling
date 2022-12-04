using AutoMapper;
using FOS.App.Student.DTOs;
using FOS.App.Student.Mappers;
using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using FOS.Student.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace FOS.Student.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentController : ExtensionController
    {
        private readonly IStudentRepo studentRepo;
        private readonly IStudentCoursesRepo studentCourses;
        private readonly IMapper mapper;
        private readonly IConfiguration _configuration;
        public StudentController(IStudentRepo studentRepo
            ,IConfiguration configuration
            ,IStudentCoursesRepo studentCoursesRepo
            ,IMapper mapper)
        {
            this.studentRepo = studentRepo;
            _configuration = configuration;
            this.studentCourses = studentCoursesRepo;
            this.mapper = mapper;
        }

        [AllowAnonymous]
        [HttpPost("Login")]
        public IActionResult Login([FromBody]LoginModel loginModel)
        {
            string hashedPassword;
            var sha512 = SHA512.Create();
            var bytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(loginModel.Password));
            hashedPassword = BitConverter.ToString(bytes).Replace("-", "");

            var student = studentRepo.Login(loginModel.Email, hashedPassword);
            if(student!=null)
            {
                var issuer = _configuration["Jwt:Issuer"];
                var audience = _configuration["Jwt:Audience"];
                var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"]);
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new[]
                    {
                        new Claim("Guid", student.Guid),
                        new Claim(JwtRegisteredClaimNames.Sub, loginModel.Email),
                        new Claim(JwtRegisteredClaimNames.Jti,student.Guid),
                    }),
                    Expires = DateTime.UtcNow.AddMinutes(10),
                    Issuer = issuer,
                    Audience = audience,
                    SigningCredentials = new SigningCredentials
                                            (new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha512Signature)
                };
                var tokenHandler = new JwtSecurityTokenHandler();
                var token = tokenHandler.CreateToken(tokenDescriptor);
                var stringToken = tokenHandler.WriteToken(token);
                var res = new
                {
                    Token = stringToken,
                };
                return Ok(res);
            }
            return Unauthorized();
        }

        [Authorize]
        //[AllowAnonymous]
        [HttpGet("GetAcademicInfo")]
        [ProducesResponseType(200, Type = typeof(StudentDTO))]
        public IActionResult GetAcademicInfo()
        {
            string? guid = GetGuid();
            if (string.IsNullOrWhiteSpace(guid))
                return BadRequest(new { msg = "Id not found"});
            DB.Models.Student student = studentRepo.Get(guid);
            if (student == null)
                return NotFound(new { msg ="Student not found" });

            List<StudentCourse> courses = studentCourses.GetCurrentAcademicYearCourses(student.Id);
            var mapedStudent = student.ToDTO(courses);
            var result4 = studentRepo.GetAll(new Core.SearchModels.StudentSearchCriteria()
            {
                Filters = new List<Core.SearchModels.SearchBaseModel>()
                {
                    new Core.SearchModels.SearchBaseModel()
                    {
                        Key = "Fname",
                        Operator = "contains",
                        Value = "Girg"
                    },
                                        new Core.SearchModels.SearchBaseModel()
                    {
                        Key = "Lname",
                        Operator = "=",
                        Value = "Fekry"
                    }
                }
            });

            return Ok(new
            {
                Data = mapedStudent
            });
            // var resul1 = studentRepo.GetAll();

            //var result2 = studentRepo.GetAll(new Core.SearchModels.StudentSearchCriteria()
            // {
            //     OrderByColumn = "FName",
            //     Ascending = false
            // });
            // var result3 = studentRepo.GetAll(new Core.SearchModels.StudentSearchCriteria()
            // {
            //     OrderByColumn = "FName",
            //     Ascending = true
            // });
            // return Ok(new { O1 = resul1, O2 = result2, O3 = result3 });

            


            //StudentViewModel s = GetStudent();
            //if (result4 == null)
            //    return BadRequest();
            //return Ok(result4);
        }
    }
}
