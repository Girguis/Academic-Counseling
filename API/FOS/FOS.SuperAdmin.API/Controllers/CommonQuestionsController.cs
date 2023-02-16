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
    public class CommonQuestionsController : ControllerBase
    {
        private readonly ILogger<CommonQuestionsController> logger;
        private readonly ICommonQuestionsRepo questionsRepo;

        public CommonQuestionsController(ILogger<CommonQuestionsController> logger, ICommonQuestionsRepo questionsRepo)
        {
            this.logger = logger;
            this.questionsRepo = questionsRepo;
        }
        [HttpPost("Add")]
        public IActionResult Add(List<QuestionModel> questions)
        {
            if (questions == null || questions.Count < 1)
                return BadRequest(new
                {
                    Massage = "List can't be empty",
                    Data = questions
                });
            var added = questionsRepo.AddQuestion(questions);
            if (!added)
                return BadRequest(new
                {
                    Massage = "Error occured while adding questions",
                    Data = questions
                });
            return Ok();
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
        [HttpGet("Get/{id}")]
        public IActionResult Get(int id)
        {
            try
            {
                var question = questionsRepo.GetQuestion(id);
                if (question == null)
                    return NotFound();
                return Ok(new
                {
                    Data = question
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpDelete("Delete/{id}")]
        public IActionResult Delete(int id)
        {
            try
            {
                var question = questionsRepo.GetQuestion(id);
                if (question == null)
                    return NotFound();
                var deleted = questionsRepo.DeleteQuestion(question);
                if (!deleted)
                    return BadRequest(new
                    {
                        Massage = "Error occured while deleting question",
                        Data = id
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
        [HttpPut("Update/{id}")]
        public IActionResult Update(int id, QuestionModel model)
        {
            var question = questionsRepo.GetQuestion(id);
            if (question == null)
                return NotFound();
            question.Answer = model.Answer;
            question.Question = model.Question;
            var updated = questionsRepo.UpdateQuestion(question);
            if (!updated)
                return BadRequest(new
                {
                    Massage = "Error occured while updating question",
                    Data = new { ID = id, Model = model }
                });
            return Ok();
        }
    }
}
