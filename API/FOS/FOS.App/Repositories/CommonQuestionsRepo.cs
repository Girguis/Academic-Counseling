using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class CommonQuestionsRepo : ICommonQuestionsRepo
    {
        private readonly FOSContext context;

        public CommonQuestionsRepo(FOSContext context)
        {
            this.context = context;
        }
        public bool AddQuestion(List<QuestionModel> questions)
        {
            List<CommonQuestion> commonQuestions = new List<CommonQuestion>();
            for (int i = 0; i < questions.Count; i++)
            {
                commonQuestions.Add(new CommonQuestion()
                {
                    Answer = questions[i].Answer,
                    Question = questions[i].Question
                });
            }
            context.CommonQuestions.AddRange(commonQuestions);
            return context.SaveChanges() > 0;
        }

        public bool DeleteQuestion(CommonQuestion question)
        {
            if (question == null)
                return false;
            context.CommonQuestions.Remove(question);
            return context.SaveChanges() > 0;
        }

        public CommonQuestion GetQuestion(int id)
        {
            return context.CommonQuestions.FirstOrDefault(x => x.Id == id);
        }

        public List<CommonQuestion> GetQuestions(out int totalCount, SearchCriteria criteria)
        {
            DbSet<CommonQuestion> commonQuestions = context.CommonQuestions;
            return DataFilter<CommonQuestion>.FilterData(commonQuestions, criteria, out totalCount);
        }

        public bool UpdateQuestion(CommonQuestion question)
        {
            if (question == null) return false;
            context.Entry(question).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
    }
}
