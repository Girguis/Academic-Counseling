using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.SearchModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
namespace FOS.Doctor.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class ProgramController : Controller
    {
        private readonly ILogger<ProgramController> logger;
        private readonly IProgramRepo programRepo;

        public ProgramController(ILogger<ProgramController> logger,IProgramRepo programRepo)
        {
            this.logger = logger;
            this.programRepo = programRepo;
        }

        [HttpPost("Add")]
        public IActionResult Add([FromBody] ProgramModel model)
        {
            try
            {
                var res = programRepo.AddProgram(model);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error occured while adding program",
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
        [HttpGet("Get/{id}")]
        public IActionResult Get(int id)
        {
            try
            {
                var program = programRepo.GetProgram(id);
                if(program == null)
                    return NotFound();
                return Ok(new
                {
                    Data = program
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }

        [HttpPost("GetAll")]
        public IActionResult GetAll([FromBody]SearchCriteria criteria)
        {
            try
            {
                var res = programRepo.GetPrograms(out int totalCount, criteria);
                return Ok(new
                {
                    TotalCount= totalCount,
                    Data = res
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
