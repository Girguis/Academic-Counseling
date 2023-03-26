using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using System.Data;

namespace FOS.App.Repositories
{
    public class CommonQuestionsRepo : ICommonQuestionsRepo
    {
        private readonly IDbContext config;

        public CommonQuestionsRepo(IDbContext config)
        {
            this.config = config;
        }
        public bool AddQuestion(List<QuestionModel> questions)
        {
            var dt = new DataTable();
            dt.Columns.Add("Question");
            dt.Columns.Add("Answer");
            for (int i = 0; i < questions.Count; i++)
                dt.Rows.Add(questions[i].Question, questions[i].Answer);
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddCommonQuestions", new List<SqlParameter>
            {
                QueryExecuterHelper.DataTableToSqlParameter(dt, "Questions", "CommonQuestionsType")
            });
        }

        public bool DeleteQuestion(int questionID)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "DELETE FROM CommonQuestion WHERE ID = " + questionID);
        }

        public CommonQuestion GetQuestion(int id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Query", "SELECT * FROM CommonQuestion WHERE ID = " + id);
            return QueryExecuterHelper.Execute<CommonQuestion>(config.CreateInstance(),
                "QueryExecuter",
                parameters).FirstOrDefault();
        }

        public List<CommonQuestion> GetQuestions(out int totalCount, SearchCriteria criteria)
        {
            DynamicParameters parameters = new();
            parameters.Add("@Question", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "question")?.Value?.ToString());
            parameters.Add("@Answer", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "answer")?.Value?.ToString());
            QueryExecuterHelper.GetPageParameters(parameters, criteria, "ID");
            using var con = config.CreateInstance();
            var questions = con.Query<CommonQuestion>
                            ("GetCommonQuestions",
                            param: parameters,
                            commandType: CommandType.StoredProcedure
                            )?.ToList();
            totalCount = QueryExecuterHelper.GetTotalCountParamValue(parameters, questions);
            return questions;
        }
        public List<CommonQuestion> GetQuestions()
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Query", "SELECT * FROM CommonQuestion");
            return QueryExecuterHelper.Execute<CommonQuestion>(config.CreateInstance(),
                "[QueryExecuter]",
                parameters);
        }

        public bool UpdateQuestion(CommonQuestion question)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(), "UpdateCommonQuestion",
                new List<SqlParameter>()
                {
                    new SqlParameter("@ID", question.Id),
                    new SqlParameter("@Answer", question.Answer),
                    new SqlParameter("@Question", question.Question)
                });
        }
    }
}
