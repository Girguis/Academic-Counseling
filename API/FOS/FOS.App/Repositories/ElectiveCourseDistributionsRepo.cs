using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class ElectiveCourseDistributionsRepo : IElectiveCourseDistributionRepo
    {
        private readonly FOSContext context;
        public ElectiveCourseDistributionsRepo(FOSContext context)
        {
            this.context = context;
        }
        public List<ElectiveCourseDistribution> GetOptionalCoursesDistibution(int programID)
        {
            return context.ElectiveCourseDistributions.Where(x => x.ProgramId == programID).ToList();
        }

        public List<ElectiveCourseDistribution> GetOptionalCoursesDistibution(int programID, int studentID)
        {
            SqlParameter programIDParam = new SqlParameter("@ProgramID", programID);
            SqlParameter studentIDParam = new SqlParameter("@StudentID", studentID);
            return context.ElectiveCourseDistributions.FromSqlRaw("exec [dbo].[GetElectiveCoursesDistribution] @ProgramID,@StudentID", programIDParam, studentIDParam).ToList();
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
