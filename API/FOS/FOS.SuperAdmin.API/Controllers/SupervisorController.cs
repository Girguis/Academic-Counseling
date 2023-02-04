using FOS.App.Doctor.DTOs;
using FOS.App.Doctor.Mappers;
using FOS.Core.IRepositories.Doctor;
using FOS.Doctor.API.Extenstions;
using FOS.Doctor.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
namespace FOS.Doctor.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize(Roles = "Admin")]
    public class SupervisorController : ControllerBase
    {
        private readonly ISupervisorRepo supervisorRepo;
        private readonly IConfiguration configuration;
        private readonly ILogger<SupervisorController> logger;

        public SupervisorController(ISupervisorRepo supervisorRepo,
                                    IConfiguration configuration,
                                    ILogger<SupervisorController> logger)
        {
            this.supervisorRepo = supervisorRepo;
            this.configuration = configuration;
            this.logger = logger;
        }
        /// <summary>
        /// Take object of LoginModel which have E-mail and password as data memebers
        /// Hashing password then send it to supervisorRepo.Login and wait for the result
        /// if supervisor is not null this means E-mail and password are correct and we will generate a new access token and send it the the client
        /// if it's null this mean either E-mail or password or both are incorrect
        /// </summary>
        /// <param name="loginModel"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost("Login")]
        public IActionResult Login([FromBody] LoginModel loginModel)
        {
            try
            {
                string hashedPassword;
                var sha512 = SHA512.Create();
                var passWithKey = "MSKISH" + loginModel.Password + "20MSKISH22";
                var bytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(passWithKey));
                hashedPassword = BitConverter.ToString(bytes).Replace("-", "");

                var supervisor = supervisorRepo.Login(loginModel.Email, hashedPassword);
                if (supervisor != null)
                {
                    var issuer = configuration["Jwt:Issuer"];
                    var audience = configuration["Jwt:Audience"];
                    var key = Encoding.ASCII.GetBytes(configuration["Jwt:Key"]);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new[]
                        {
                            new Claim("Guid", supervisor.Guid),
                            new Claim(ClaimTypes.Role,"Admin")
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
        /// Get informations of logged in supervisor by GUID
        /// GUID if retrived from access token, which is sent from the client-side in the header
        /// Retrives supervisor by GUID and map it to SupervisorDTO model
        /// </summary>
        /// <returns>Supervior details</returns>
        [HttpGet("GetSuperviorInfo")]
        [ProducesResponseType(200, Type = typeof(SupervisorDTO))]
        public IActionResult GetSuperviorInfo()
        {
            try
            {
                string? guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new { Massage = "Id not found" });

                DB.Models.Supervisor supervisor = supervisorRepo.Get(guid);
                if (supervisor == null)
                    return NotFound(new { Massage = "Supervisor not found" });

                SupervisorDTO supervisorDTO = supervisor.ToDTO();
                return Ok(supervisorDTO);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

    }
}