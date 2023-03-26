using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using System.ComponentModel.DataAnnotations;

namespace FOS.App.Repositories
{
    public class StatisticsRepo : IStatisticsRepo
    {
        private readonly IDbContext config;

        public StatisticsRepo(IDbContext config)
        {
            this.config = config;
        }

        public List<StatisticsOutModel> GetCourseStatistics(CourseStatisticsParameterModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@CourseID", model.CourseID);
            parameters.Add("@AcademicYearID", model.AcademicYearID);
            return QueryExecuterHelper.Execute<StatisticsOutModel>(config.CreateInstance()
                , "Statistics_CourseGrades", parameters);
        }

        public List<StatisticsOutModel> GetGendersStatistics()
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Query", "SELECT COUNT(ID) AS [Value],Gender AS [Key]" +
                " FROM Student GROUP BY Gender");
            var data = QueryExecuterHelper.Execute<StatisticsOutModel>(config.CreateInstance(),
                "QueryExecuter",
                parameters);

            return data.Select(x => new StatisticsOutModel
            {
                Key = string.IsNullOrEmpty(x.Key.ToString()) ? x.Key : Helper.GetDisplayName((GenderEnum)int.Parse(x.Key.ToString())),
                Value = x.Value
            })?.ToList();
        }

        public List<StatisticsOutModel> GetProgramsStatistics()
        {
            return QueryExecuterHelper.Execute<StatisticsOutModel>(config.CreateInstance(), "Statistics_Programs", null);
        }

        public List<StatisticsOutModel> GetStudentsGradesStatistics(StudentsGradesParatmeterModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramID", model.ProgramID);
            parameters.Add("@IsActive", model.IsActive);
            parameters.Add("@IsGraduated", model.IsGraudated);
            return QueryExecuterHelper.Execute<StatisticsOutModel>(config.CreateInstance(), "Statistics_StudentGrades", parameters);
        }
    }
}