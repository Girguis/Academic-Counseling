using FOS.Core.IRepositories.Supervisor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Supervisor.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    //[Authorize]
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
                var res = bifurcationRepo.BifurcateStudents();
                if (res == null)
                    return BadRequest();
                return Ok(res);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
    }
}
