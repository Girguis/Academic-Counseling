using FOS.App.Doctors.DTOs;
using FOS.App.Doctors.Mappers;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.Doctors.API.Extenstions;
using FOS.Doctors.API.Mappers;
using FOS.Doctors.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class DoctorController : ControllerBase
    {
        private readonly IDoctorRepo supervisorRepo;
        private readonly IConfiguration configuration;
        private readonly ILogger<DoctorController> logger;

        public DoctorController(IDoctorRepo supervisorRepo,
                                    IConfiguration configuration,
                                    ILogger<DoctorController> logger)
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
                string hashedPassword = Helper.HashPassowrd(loginModel.Password);
                var supervisor = supervisorRepo.Login(loginModel.Email, hashedPassword);
                if (supervisor != null)
                {
                    var roleName = Enum.GetName((DoctorTypesEnum)supervisor.Type);
                    var issuer = configuration["Jwt:Issuer"];
                    var audience = configuration["Jwt:Audience"];
                    var key = Encoding.ASCII.GetBytes(configuration["Jwt:Key"]);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new[]
                        {
                            new Claim("Guid", supervisor.Guid),
                            new Claim(ClaimTypes.Role,roleName??"Doctor"),
                            new Claim("ProgramID",supervisor.ProgramId.ToString())
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
                        Massage = "success",
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
        /// <summary>
        /// Get informations of logged in supervisor by GUID
        /// GUID if retrived from access token, which is sent from the client-side in the header
        /// Retrives supervisor by GUID and map it to DoctorDTO model
        /// </summary>
        /// <returns>Supervior details</returns>
        [HttpGet("GetInfo")]
        [ProducesResponseType(200, Type = typeof(DoctorDTO))]
        public IActionResult GetInfo()
        {
            try
            {
                string? guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new { Massage = "Id not found" });

                DB.Models.Doctor supervisor = supervisorRepo.GetById(guid);
                if (supervisor == null)
                    return NotFound(new { Massage = "Doctor not found" });

                DoctorDTO supervisorDTO = supervisor.ToDTO();
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
                if (string.IsNullOrWhiteSpace(guid)) return NotFound();
                var supervisor = supervisorRepo.GetById(guid);
                if (supervisor == null) return NotFound(new { Massage = "Doctor not found" });
                DoctorDTO supervisorDTO = supervisor.ToDTO();
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
                List<DoctorDTO> supervisorDTOs = new List<DoctorDTO>();
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
        public IActionResult Add(DoctorAddModel supervisor)
        {
            try
            {
                if (supervisorRepo.IsEmailReserved(supervisor.Email))
                    return BadRequest(new
                    {
                        Massage = "Email Already Used",
                        Data = supervisor
                    });
                supervisor.Password = Helper.HashPassowrd(supervisor.Password);
                var mappedDoctor = supervisor.ToDBDoctorModel(true);
                var res = supervisorRepo.Add(mappedDoctor);
                if (res == null)
                    return BadRequest(new
                    {
                        Massage = "Error Occured While Adding Doctor",
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
        [HttpDelete("Deactivate/{guid}")]
        public IActionResult Deactivate(string guid)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(guid)) return NotFound();
                var res = supervisorRepo.Deactivate(guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error Occured While Deactivating Doctor account",
                        Data = guid
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
                if (string.IsNullOrWhiteSpace(model.Guid)) return NotFound();
                var res = supervisorRepo.Activate(model.Guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error Occured While Activating Doctor account",
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
        [HttpPut("Update/{guid}")]
        public IActionResult Update(string guid, DoctorUpdateModel supervisorModel)
        {
            try
            {
                var supervisor = supervisorRepo.GetById(guid);
                if (supervisor == null) return NotFound(new { Massage = "Doctor not found" });

                if (supervisor.Email != supervisorModel.Email 
                    && supervisorRepo.IsEmailReserved(supervisorModel.Email))
                {
                    return BadRequest(new
                    {
                        Massage = "Email Already Used",
                        Data = supervisor
                    });
                }
                supervisor = supervisor.DoctorUpdater(supervisorModel);
                var res = supervisorRepo.Update(supervisor);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error Occured While Updating Doctor",
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

        [HttpPost]
        [Route("ChangePassword")]
        [Route("ChangePassword/{guid}")]
        public IActionResult ChangePassword(string guid, ChangePasswordModel model)
        {
            try
            {
                if (string.IsNullOrEmpty(guid))
                    guid = this.Guid();
                var supervisor = supervisorRepo.GetById(guid);
                if (supervisor == null) return NotFound();
                supervisor.Password = Helper.HashPassowrd(model.Password);
                var updated = supervisorRepo.Update(supervisor);
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