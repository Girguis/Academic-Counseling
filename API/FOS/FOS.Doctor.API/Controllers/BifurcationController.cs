using FOS.Core.Languages;
using FOS.Core.IRepositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using FOS.Core.Configs;
using FOS.App.Helpers;

namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize(Roles = "SuperAdmin")]
    public class BifurcationController : Controller
    {
        private readonly IBifurcationRepo bifurcationRepo;
        private readonly ILogger<BifurcationController> logger;

        public BifurcationController(IBifurcationRepo bifurcationRepo,
                                    ILogger<BifurcationController> logger)
        {
            this.bifurcationRepo = bifurcationRepo;
            this.logger = logger;
        }
        [HttpGet("BifurcateStudents")]
        public IActionResult GetBifurcationResult()
        {
            try
            {
                var stream = bifurcationRepo.BifurcateStudents();
                if (stream == null)
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred
                    });
                return File(stream,
                    "application/vnd.ms-excel",
                    "BirfucationResult" + DateTime.UtcNow.AddHours(Helper.GetUtcOffset()).ToString() + ".xlsx");
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
