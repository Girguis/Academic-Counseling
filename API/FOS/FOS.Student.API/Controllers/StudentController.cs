﻿using FOS.App.Student.DTOs;
using FOS.App.Student.Mappers;
using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using FOS.Student.API.Extensions;
using FOS.Student.API.Models;
using Microsoft.AspNetCore.Authorization;
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
    [ApiVersion("1.0")]
    [Authorize]
    public class StudentController : ControllerBase
    {
        private readonly IStudentRepo studentRepo;
        private readonly IStudentCoursesRepo studentCourses;
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
            studentCourses = studentCoursesRepo;
            this.academicYearRepo = academicYearRepo;
            this.logger = logger;
        }

        [AllowAnonymous]
        [HttpPost("Login")]
        public IActionResult Login([FromBody] LoginModel loginModel)
        {
            try
            {
                string hashedPassword;
                var sha512 = SHA512.Create();
                //Add secret value to password 
                var passWithKey = "MSKISH" + loginModel.Password + "20MSKISH22";
                //Compute hash value
                var bytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(passWithKey));
                //Casting it to string
                hashedPassword = BitConverter.ToString(bytes).Replace("-", "");
                //Get student by email & password
                var student = studentRepo.Login(loginModel.Email, hashedPassword);
                //If student object is null this mean either email or password is incorrect
                if (student != null)
                {
                    //Generating access token
                    var issuer = _configuration["Jwt:Issuer"];
                    var audience = _configuration["Jwt:Audience"];
                    var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"]);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new[]
                        {
                        new Claim("Guid", student.Guid),
                    }),
                        Expires = DateTime.UtcNow.AddHours(6),
                        Issuer = issuer,
                        Audience = audience,
                        SigningCredentials = new SigningCredentials
                                                (new SymmetricSecurityKey(key),
                                                SecurityAlgorithms.HmacSha512Signature)
                    };
                    var tokenHandler = new JwtSecurityTokenHandler();
                    //Token is generated here
                    var token = tokenHandler.CreateToken(tokenDescriptor);
                    //Encrypting token then sending it to the client
                    var stringToken = tokenHandler.WriteToken(token);
                    var res = new
                    {
                        Token = stringToken,
                    };
                    return Ok(res);
                }
                return Unauthorized();
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
                    return BadRequest(new { msg = "Id not found" });

                DB.Models.Student student = studentRepo.Get(guid);
                if (student == null)
                    return NotFound(new { msg = "Student not found" });

                List<StudentCourse> courses = studentCourses.GetCurrentAcademicYearCourses(student.Id);
                var mapedStudent = student.ToDTO(courses, academicYearRepo.GetCurrentYear());
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
    }
}
