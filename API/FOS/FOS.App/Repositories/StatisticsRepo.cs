using Dapper;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
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

        public List<StatisticsOutModel> GetCourseStatistics(CourseStatisticsParameterModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@CourseID", model.CourseID);
            parameters.Add("@AcademicYearID", model.AcademicYearID);
            return QueryExecuterHelper.Execute<StatisticsOutModel>(connectionString, "Statistics_CourseGrades", parameters);
        }

        public List<StatisticsOutModel> GetGendersStatistics()
        {
            return context.Students.GroupBy(x => x.Gender).Select(x => new StatisticsOutModel
            {
                Key = string.IsNullOrEmpty(x.Key) ? x.Key : Helper.GetEnumDescription((GenderEnum)int.Parse(x.Key)),
                Value = x.Count()
            })?.ToList();
        }

        public List<StatisticsOutModel> GetProgramsStatistics()
        {
            return QueryExecuterHelper.Execute<StatisticsOutModel>(connectionString, "Statistics_Programs", null);
        }

        public List<StatisticsOutModel> GetStudentsGradesStatistics(StudentsGradesParatmeterModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramID", model.ProgramID);
            parameters.Add("@IsActive", model.IsActive);
            parameters.Add("@IsGraduated", model.IsGraudated);
            return QueryExecuterHelper.Execute<StatisticsOutModel>(connectionString, "Statistics_StudentGrades", parameters);
        }
    }
}