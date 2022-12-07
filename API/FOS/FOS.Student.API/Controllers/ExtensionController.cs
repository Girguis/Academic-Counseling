﻿using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExtensionController : ControllerBase
    {
        internal string? GetGuid()
        {
            return HttpContext.User.Claims.FirstOrDefault(x => x.Type == "Guid")?.Value;
        }
    }
}
