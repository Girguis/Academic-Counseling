using Dapper;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.DB.Models;
using Microsoft.Extensions.Configuration;

namespace FOS.App.Repositories
{
    public class StatisticsRepo : IStatisticsRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public StatisticsRepo(FOSContext context, IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }
        public List<StatisticsModel> GetGendersStatistics()
        {
            return context.Students.GroupBy(x => x.Gender).Select(x => new StatisticsModel
            {
                Key = x.Key,
                Value = x.Count()
            })?.ToList();
        }

        public List<StatisticsModel> GetProgramsStatistics()
        {
            return QueryHelper.Execute<StatisticsModel>(connectionString, "ProgramsStatistics", null);
        }

        public List<StatisticsModel> GetStudentsGradesStatistics(StudentsGradesParatmeterModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramID", model.ProgramID);
            parameters.Add("@IsActive", model.IsActive);
            parameters.Add("@IsGraduated", model.IsGraudated);
            return QueryHelper.Execute<StatisticsModel>(connectionString, "StudentGradesStatistics", parameters);
        }
    }
}