using AutoMapper;
using FOS.App.Supervisor.DTOs;
using FOS.App.Supervisor.Mappers;
using FOS.Core.IRepositories.Supervisor;
using FOS.Supervisor.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
namespace FOS.Supervisor.API.Controllers
{
    public class SupervisorController : ExtensionController
    {
        private readonly ISupervisorRepo supervisorRepo;
        private readonly IMapper mapper;
        private readonly IConfiguration configuration;

        public SupervisorController(
            ISupervisorRepo supervisorRepo,
            IMapper mapper
            , IConfiguration configuration)
        {
            this.supervisorRepo = supervisorRepo;
            this.mapper = mapper;
            this.configuration = configuration;
        }

        [AllowAnonymous]
        [HttpPost("Login")]
        public IActionResult Login([FromBody] LoginModel loginModel)
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
                        new Claim(JwtRegisteredClaimNames.Sub, loginModel.Email),
                        new Claim(JwtRegisteredClaimNames.Jti,supervisor.Guid),
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

        [HttpGet("GetSuperviorInfo")]
        [ProducesResponseType(200, Type = typeof(SupervisorDTO))]
        public IActionResult GetSuperviorInfo()
        {
            string? guid = GetGuid();
            if (string.IsNullOrWhiteSpace(guid))
                return BadRequest(new { msg = "Id not found" });
            DB.Models.Supervisor supervisor = supervisorRepo.Get(guid);
            if (supervisor == null)
                return NotFound(new { msg = "Supervisor not found" });
            SupervisorDTO supervisorDTO = supervisor.ToDTO();
            return Ok(supervisorDTO);
        }

    }
}