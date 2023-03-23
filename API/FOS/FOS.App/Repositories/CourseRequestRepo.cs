using Dapper;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using Microsoft.Extensions.Configuration;

namespace FOS.App.Repositories
{
    public class CourseRequestRepo : ICourseRequestRepo
    {
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public CourseRequestRepo(IConfiguration configuration)
        {
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }
        public bool DeleteRequest(string requestID, int? studentID = null)
        {
            var query = "DELETE FROM StudentCourseRequest WHERE RequestID = '" + requestID+"'";
            if (studentID != null)
                query += " AND StudentID = " + studentID;
            return QueryExecuterHelper
                .Execute(connectionString, query);
        }
        public List<CourseRequestOutModel> GetRequests(CourseRequestParamModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@RequestID", model.RequestID);
            parameters.Add("@RequestTypeID", model.RequestTypeID);
            parameters.Add("@StudentID", model.StudentID);
            parameters.Add("@IsApproved", model.IsApproved);
            return QueryExecuterHelper.Execute<CourseRequestOutModel>
                (connectionString,
                "GetCoursesRequests",
                parameters);
        }

        public bool HandleRequest(string requestID, bool isAccepted)
        {
            return QueryExecuterHelper
                .ExecuteQuery(connectionString,
                "Update StudentCourseRequest SET IsApproved = " + isAccepted
                + "WHERE RequestID = " + requestID);
        }
    }
}
