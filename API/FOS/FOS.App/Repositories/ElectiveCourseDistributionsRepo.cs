using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.DB.Models;

namespace FOS.App.Repositories
{
    public class ElectiveCourseDistributionsRepo : IElectiveCourseDistributionRepo
    {
        private readonly IDbContext config;

        public ElectiveCourseDistributionsRepo(IDbContext config)
        {
            this.config = config;
        }
        public List<ElectiveCourseDistribution> GetOptionalCoursesDistibution(int studentID,
            bool isForOverload = false,
            bool isForEnhancement = false)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            parameters.Add("@IsForOverload", isForOverload);
            parameters.Add("@IsForEnhancement", isForEnhancement);
            return QueryExecuterHelper.Execute<ElectiveCourseDistribution>(config.CreateInstance(),
                            "GetElectiveCoursesDistribution", parameters);
        }

        //public int GetSumOfPassedHours(int studentProgram,int studentID,int courseLevel,int courseSemester,int courseType,int courseCategory)
        //{
        //    var res = QueryHelper.ExecuteFunction(configuration["FosDB"], "GetSumOfPassedHours", new List<object>()
        //    {
        //        studentProgram,studentID,courseLevel,courseSemester,courseType,courseCategory
        //    });
        //    return res == null ? 0 : (int)res;
        //}
    }
}
