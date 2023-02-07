using FOS.App.Doctor.DTOs;
using FOS.App.Doctor.Mappers;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.Doctor.API.Extenstions;
using FOS.Doctor.API.Mappers;
using FOS.Doctor.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
namespace FOS.Doctor.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
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
                string hashedPassword = this.HashPassowrd(loginModel.Password);
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
              //              new Claim(ClaimTypes.Role,"Admin")
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

                DB.Models.Supervisor supervisor = supervisorRepo.GetById(guid);
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
        [HttpGet("GetByID/{guid}")]
        public IActionResult GetByID(string guid)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(guid)) return NoContent();
                var supervisor = supervisorRepo.GetById(guid);
                if (supervisor == null) return NotFound(new { Massage = "Supervisor not found" });
                SupervisorDTO supervisorDTO = supervisor.ToDTO();
                return Ok(supervisorDTO);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("GetAll")]
        public IActionResult GetAll(SearchCriteria criteria)
        {
            try
            {
                var supervisors = supervisorRepo.GetAll(out int totalCount, criteria);
                List<SupervisorDTO> supervisorDTOs = new List<SupervisorDTO>();
                for (int i = 0; i < supervisors.Count; i++)
                    supervisorDTOs.Add(supervisors.ElementAt(i).ToDTO());
                return Ok(new
                {
                    Data = supervisorDTOs,
                    TotalCount = totalCount
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("Add")]
        public IActionResult Add(SupervisorModel supervisor)
        {
            try
            {
                if (supervisorRepo.IsEmailReserved(supervisor.Email))
                    return BadRequest(new
                    {
                        Massage = "Email Already Used",
                        Data = supervisor
                    });
                supervisor.Password = this.HashPassowrd(supervisor.Password);
                var mappedSupervisor = supervisor.ToDBSupervisorModel(true);
                var res = supervisorRepo.Add(mappedSupervisor);
                if (res == null)
                    return BadRequest(new
                    {
                        Massage = "Error Occured While Adding Supervisor",
                        Data = supervisor
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpDelete("Delete/{guid}")]
        public IActionResult Delete(string guid)
        {
            if (string.IsNullOrWhiteSpace(guid)) return NoContent();
            var res = supervisorRepo.Delete(guid);
            if (!res)
                return BadRequest(new
                {
                    Massage = "Error Occured While Deleting Supervisor",
                    Data = guid
                });
            return Ok();
        }
        //eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJHdWlkIjoiQTk1QTQzMDQtRTIxNS00NkEzLUEzQzktM0QwMUY5MEYwODY4IiwibmJmIjoxNjc1ODAyNjA3LCJleHAiOjE2NzU4MjQyMDYsImlhdCI6MTY3NTgwMjYwNywiaXNzIjoiaGZkdWV3aHJwN3luNTQ0M3U5cGlyZnR0NXl1aGdmY3hkZmVyNTY0dzhteW4zOXdvcDkzbXo0dTJuN256MzI0NnRiajZ0ejU2MzJjcjUiLCJhdWQiOiIydnQzN2JubXpodm5mc2pid3RubXl1am1hd2VzcnRmZ3lodWppa21uY3hkZXM0NTZ5N3VpamhidmNkeHNlNDU2NzhpOW9rbG1uYiJ9.Hwc4PAeSQQYKmpsJUvF5sHKTMDqPaOLLgiBzOOwlYRYfbKACSzhHDUsDCOzG-E7m0PC85_QQ01_z9SPbHS6LAg
        [HttpPut("Update")]
        public IActionResult Update(SupervisorModel supervisorModel)
        {
            try
            {
                var supervisor = supervisorRepo.GetById(supervisorModel.Guid);
                if (supervisor == null) return NotFound(new { Massage = "Supervisor not found" });
                supervisorModel.Password = this.HashPassowrd(supervisorModel.Password);
                supervisor = supervisor.SupervisorUpdater(supervisorModel);
                var res = supervisorRepo.Update(supervisor);
                if (res == null)
                    return BadRequest(new
                    {
                        Massage = "Error Occured While Updating Supervisor",
                        Data = supervisorModel
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