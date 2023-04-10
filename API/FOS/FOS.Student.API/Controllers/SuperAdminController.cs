using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
using FOS.Core.Models;
using FOS.Core.Models.StoredProcedureOutputModels;
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
    [Authorize(Roles = "SuperAdmin")]
    public class SuperAdminController : ControllerBase
    {
        private readonly ISuperAdminRepo superAdminRepo;
        private readonly IStudentCoursesRepo studentCoursesRepo;
        private readonly ILogger<SuperAdminController> logger;
        private readonly IConfiguration configuration;

        public SuperAdminController(ISuperAdminRepo superAdminRepo,
            IStudentCoursesRepo studentCoursesRepo,
            ILogger<SuperAdminController> logger,
            IConfiguration configuration)
        {
            this.superAdminRepo = superAdminRepo;
            this.studentCoursesRepo = studentCoursesRepo;
            this.logger = logger;
            this.configuration = configuration;
        }
        [AllowAnonymous]
        [HttpPost("SuperAdminLogin")]
        public IActionResult Login([FromBody] LoginModel loginModel)
        {
            try
            {
                string hashedPassword = Helper.HashPassowrd(loginModel.Password);
                var superAdmin = superAdminRepo.Login(loginModel.Email, hashedPassword);
                if (superAdmin != null)
                {
                    var issuer = configuration["Jwt:Issuer"];
                    var audience = configuration["Jwt:Audience"];
                    var key = Encoding.ASCII.GetBytes(configuration["Jwt:Key"]);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new[]
                        {
                            new Claim("Guid", superAdmin.Guid),
                            new Claim(ClaimTypes.Role, "SuperAdmin"),
                            new Claim("ProgramID", "")
                        }),
                        Expires = DateTime.UtcNow.AddHours(6),
                        Issuer = issuer,
                        Audience = audience,
                        SigningCredentials = new SigningCredentials
                                                (new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha512Signature)
                    };
                    var tokenHandler = new JwtSecurityTokenHandler();
                    var token = tokenHandler.CreateToken(tokenDescriptor);
                    var stringToken = tokenHandler.WriteToken(token);
                    return Ok(new
                    {
                        Token = stringToken
                    });
                }
                return Unauthorized();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("GetAllRegistrations")]
        [ProducesResponseType(200, Type = typeof(GetAllCoursesRegistrationModel))]
        public IActionResult GetAllRegistrations()
        {
            try
            {
                return Ok(studentCoursesRepo.GetAllRegistrations());
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpGet("GetAppSettings")]
        [ProducesResponseType(200, Type = typeof(AppSettingsModel))]
        public IActionResult GetAppSettings()
        {
            try
            {
                var model = new AppSettingsModel(configuration);
                return Ok(model);
            }
            catch(Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("ModifyAppSettings")]
        public IActionResult ModifyAppSetting(AppSettingsModel model)
        {
            try
            {
                Helper.UpdateAppSettings(model);
                return Ok();
            }
            catch(Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("DataForAnalysisTeam")]
        public IActionResult DataForAnalysisTeam()
        {
            try
            {
                return Ok(new
                {
                    Students = studentCoursesRepo.GetStudentsForAnalysis(),
                    StudentsSemestersGPA = studentCoursesRepo.GetStudentsGpasForAnalysis(),
                    DoctorsCourses = studentCoursesRepo.GetDoctorsCoursesForAnalysis(),
                    StudentsCourses = studentCoursesRepo.GetStudentsCoursesForAnalysis()
                });
            }catch(Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
