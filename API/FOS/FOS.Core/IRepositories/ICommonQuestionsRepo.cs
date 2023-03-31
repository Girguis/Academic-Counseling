using FOS.Core.Models;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ICommonQuestionsRepo
    {
        CommonQuestion GetQuestion(int id);
        List<CommonQuestion> GetQuestions(out int totalCount,SearchCriteria criteria);
        List<CommonQuestion> GetQuestions();
        bool AddQuestion(QuestionModel question);
        bool UpdateQuestion(CommonQuestion question);
        bool DeleteQuestion(int questionID);
    }
}
