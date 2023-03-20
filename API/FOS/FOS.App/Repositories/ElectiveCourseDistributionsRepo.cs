using Dapper;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Extensions.Configuration;

namespace FOS.App.Repositories
{
    public class ElectiveCourseDistributionsRepo : IElectiveCourseDistributionRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public ElectiveCourseDistributionsRepo(FOSContext context,IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }
        public List<ElectiveCourseDistribution> GetOptionalCoursesDistibution(int studentID,
            bool isForOverload = false,
            bool isForEnhancement = false)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            parameters.Add("@IsForOverload", isForOverload);
            parameters.Add("@IsForEnhancement", isForEnhancement);
            return QueryHelper.Execute<ElectiveCourseDistribution>(connectionString,
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
