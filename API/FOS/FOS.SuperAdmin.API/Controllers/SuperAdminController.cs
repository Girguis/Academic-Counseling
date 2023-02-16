using FOS.App.Doctor.DTOs;
using FOS.App.Doctor.Mappers;
using FOS.Core.IRepositories;
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
    public class SuperAdminController : ControllerBase
    {
        private readonly ISuperAdminRepo superAdminRepo;
        private readonly IConfiguration configuration;
        private readonly ILogger<SuperAdminController> logger;

        public SuperAdminController(ISuperAdminRepo superAdminRepo,
                                    IConfiguration configuration,
                                    ILogger<SuperAdminController> logger)
        {
            this.superAdminRepo = superAdminRepo;
            this.configuration = configuration;
            this.logger = logger;
        }
        /// <summary>
        /// Take object of LoginModel which have E-mail and password as data memebers
        /// Hashing password then send it to superAdminRepo.Login and wait for the result
        /// if superAdmin is not null this means E-mail and password are correct and we will generate a new access token and send it the the client
        /// if it's null this mean either E-mail or password or both are incorrect
        /// </summary>
        /// <param name="loginModel"></param>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpPost("SuperAdminLogin")]
        public IActionResult Login([FromBody] LoginModel loginModel)
        {
            try
            {
                string hashedPassword;
                var sha512 = SHA512.Create();
                var passWithKey = "MSKISH" + loginModel.Password + "20MSKISH22";
                var bytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(passWithKey));
                hashedPassword = BitConverter.ToString(bytes).Replace("-", "");

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
                            new Claim(ClaimTypes.Role, "Admin")
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
        /// Get informations of logged in superAdmin by GUID
        /// GUID if retrived from access token, which is sent from the client-side in the header
        /// Retrives superAdmin by GUID and map it to superAdminDTO model
        /// </summary>
        /// <returns>superadmin details</returns>
        [HttpGet("GetSuperAdminInfo")]
        [ProducesResponseType(200, Type = typeof(SuperAdminDTO))]
        public IActionResult GetSuperAdminInfo()
        {
            try
            {
                string? guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new { Massage = "Id not found" });

                DB.Models.SuperAdmin superAdmin = superAdminRepo.Get(guid);
                if (superAdmin == null)
                    return NotFound(new { Massage = "superAdmin not found" });

                SuperAdminDTO superAdminDTO = superAdmin.ToDTO();
                return Ok(superAdminDTO);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("ChangePassword")]
        public IActionResult ChangePassword(ChangePasswordModel model)
        {
            try
            {
                string guid = this.Guid();
                if (string.IsNullOrEmpty(guid))
                    return BadRequest();

                var superAdmin = superAdminRepo.Get(guid);
                if (superAdmin == null) return NotFound();
                superAdmin.Password = this.HashPassowrd(model.Password);
                var updated = superAdminRepo.Update(superAdmin);
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
