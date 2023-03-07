using FOS.Core.IRepositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Students.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class CommonQuestionsController : Controller
    {
        private readonly ILogger<CommonQuestionsController> logger;
        private readonly ICommonQuestionsRepo questionsRepo;

        public CommonQuestionsController(ILogger<CommonQuestionsController> logger, ICommonQuestionsRepo questionsRepo)
        {
            this.logger = logger;
            this.questionsRepo = questionsRepo;
        }
        [HttpPost("GetAll")]
        public IActionResult GetAll()
        {
            try
            {
                var questions = questionsRepo.GetQuestions();
                return Ok(questions);
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }
}
