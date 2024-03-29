﻿using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Languages;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using FOS.Doctors.API.Extenstions;
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
        private readonly IDoctorRepo doctorRepo;
        private readonly IConfiguration configuration;
        private readonly ILogger<DoctorController> logger;

        public DoctorController(IDoctorRepo doctorRepo,
                                    IConfiguration configuration,
                                    ILogger<DoctorController> logger)
        {
            this.doctorRepo = doctorRepo;
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
                var doctor = doctorRepo.Login(loginModel.Email, hashedPassword);
                if (doctor != null)
                {
                    if (!doctor.IsActive)
                        return Unauthorized(new
                        {
                            Message = Resource.InActiveAccount
                        });
                    var stringToken = Helper.GenerateToken(new[]{
                            new Claim("Guid", doctor.Guid),
                            new Claim(ClaimTypes.Role,Enum.GetName((DoctorTypesEnum)doctor.Type)??"Doctor"),
                            new Claim("ProgramID",doctor.ProgramGuid)
                        });
                    return Ok(new
                    {
                        Massage = "success",
                        Token = stringToken
                    });
                }
                return Unauthorized(new { Message = Resource.InvalidEmailOrPassword });
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
        [ProducesResponseType(200, Type = typeof(DoctorOutModel))]
        public IActionResult GetInfo()
        {
            try
            {
                string? guid = this.Guid();
                if (string.IsNullOrWhiteSpace(guid))
                    return BadRequest(new { Massage = Resource.InvalidID });

                var doctor = doctorRepo.GetById(guid);
                if (doctor == null)
                    return NotFound(new { Massage = Resource.InvalidID });

                return Ok(doctor);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpGet("GetByID/{guid}")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult GetByID(string guid)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(guid)) return NotFound();
                var doctor = doctorRepo.GetById(guid);
                if (doctor == null) return NotFound();
                return Ok(doctor);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("GetAll")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult GetAll(SearchCriteria criteria)
        {
            try
            {
                var doctors = doctorRepo.GetAll(out int totalCount, criteria);
                return Ok(new
                {
                    Data = doctors,
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
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult Add(DoctorAddParamModel doctor)
        {
            try
            {
                if (doctorRepo.IsEmailReserved(doctor.Email))
                    return BadRequest(new
                    {
                        Massage = Resource.EmailExist,
                        Data = doctor
                    });
                var res = doctorRepo.Add(doctor);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = doctor
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPost("Deactivate")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult Deactivate([FromBody] GuidModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.Guid)) return BadRequest(new
                {
                    Massage = Resource.InvalidID
                });
                var res = doctorRepo.Deactivate(model.Guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
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
        [HttpPost("Activate")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult Activate([FromBody] GuidModel model)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(model.Guid)) return BadRequest(new
                {
                    Massage = Resource.InvalidID
                });
                var res = doctorRepo.Activate(model.Guid);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
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
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult Update(string guid, DoctorUpdateParamModel doctorModel)
        {
            try
            {
                var doctor = doctorRepo.GetById(guid);
                if (doctor == null) return NotFound(
                    new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Doctor)
                    });

                if (doctor.Email != doctorModel.Email
                    && doctorRepo.IsEmailReserved(doctorModel.Email))
                {
                    return BadRequest(new
                    {
                        Massage = Resource.EmailExist,
                        Data = doctor
                    });
                }
                var res = doctorRepo.Update(guid, doctorModel);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
                        Data = doctorModel
                    });
                return Ok();
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
                var guid = this.Guid();
                if (string.IsNullOrEmpty(guid))
                    guid = this.Guid();
                var doctor = doctorRepo.GetById(guid);
                if (doctor == null) return NotFound(
                    new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Doctor)
                    });
                var updated = doctorRepo.ChangePassword(guid, model.Password);
                if (!updated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
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
        [HttpPost("ChangePassword/{guid}")]
        [Authorize(Roles = "SuperAdmin,ProgramAdmin")]
        public IActionResult ChangePassword(string guid, ChangePasswordModel model)
        {
            try
            {
                if (string.IsNullOrEmpty(guid))
                    return BadRequest(new { Massage = Resource.InvalidID });
                var doctor = doctorRepo.GetById(guid);
                if (doctor == null) return NotFound(
                    new
                    {
                        Massage = string.Format(Resource.DoesntExist, Resource.Doctor)
                    });
                var updated = doctorRepo.ChangePassword(guid, model.Password);
                if (!updated)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred,
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
        [HttpPost("AssignSupervisorsToStudentsRandomly")]
        [Authorize(Roles = "SuperAdmin")]
        public IActionResult AssignSupervisorsToStudentsRandomly()
        {
            try
            {
                if (!doctorRepo.AssignSupervisorsToStudentsRandomly())
                    return BadRequest(new { Massage = Resource.ErrorOccurred });
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