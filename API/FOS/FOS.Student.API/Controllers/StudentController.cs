using FOS.Core.IRepositories;
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
    public class StudentController : ControllerBase
    {
        private readonly IStudentRepo studentRepo;
        private readonly IStudentCourses studentCourses;

        public StudentController(IStudentRepo studentRepo,IConfiguration configuration,IStudentCourses studentCourses)
        {
            this.studentRepo = studentRepo;
            _configuration = configuration;
            this.studentCourses = studentCourses;
        }

        public IConfiguration _configuration { get; }

        [AllowAnonymous]
        [HttpPost("Login")]
        public IActionResult Login([FromBody]LoginModel loginModel)
        {
            var hashedPassword = new StringBuilder();
            using (var sha512 = SHA512.Create())
            {
                var bytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(loginModel.Password));
                for (int i = 0; i < bytes.Length; i++)
                {
                    hashedPassword.Append(bytes[i].ToString());
                }
            }
            var student = studentRepo.Login(loginModel.Email, hashedPassword.ToString());
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
                        new Claim("Name", student.Fname),
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
                    ValidUntil = tokenDescriptor.Expires.Value.ToString()
                };
                return Ok(res);
            }
            return Unauthorized();
        }

        [Authorize]
        [HttpGet("GetStudentData")]
        public IActionResult GetStudentData()
        {
            StudentViewModel s = GetStudent();
            if (s == null)
                return BadRequest();
            return Ok(s);
        }
        private StudentViewModel GetStudent()
        {
            string guid = HttpContext.User.Claims.FirstOrDefault(x=>x.Type == "Guid").Value;
            DB.Models.Student student = studentRepo.Get(guid);
            StudentViewModel model = new StudentViewModel
            {
                Fname = student.Fname,
                MName = student.Mname,
                LName= student.Lname,
                CGpa = student.Cgpa,
                Level =student.Level,
                NumberOfWarnings =student.WarningsNumber,
                PhoneNumber = student.PhoneNumber,
                SupervisorName =student.Supervisor?.Fname,
            };
            
            return model;
        }
    }
}
