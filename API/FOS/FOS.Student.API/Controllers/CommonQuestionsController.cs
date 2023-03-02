using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
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
        public IActionResult GetAll(SearchCriteria criteria)
        {
            try
            {
                var questions = questionsRepo.GetQuestions(out int totalCount, criteria);
                return Ok(new
                {
                    Data = questions,
                    TotalCount = totalCount
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
