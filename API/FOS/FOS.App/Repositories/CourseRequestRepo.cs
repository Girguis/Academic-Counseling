using Dapper;
using FOS.App.Helpers;
using FOS.Core.Enums;
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
            var res = QueryExecuterHelper.Execute<CourseRequestOutModel>
                (connectionString,
                "GetCoursesRequests",
                parameters);
            for (int i = 0; i < res.Count; i++)
            {
                res.ElementAt(i).CourseOperation = res.ElementAt(i).CourseOperationID ? Helper.GetEnumDescription(CourseOperationEnum.Addtion) : Helper.GetEnumDescription(CourseOperationEnum.Deletion);
                res.ElementAt(i).RequestType = Helper.GetEnumDescription((CourseRequestEnum)res.ElementAt(i).RequestTypeID);
            }
            return res;
        }

        public bool HandleRequest(string requestID, bool isAccepted)
        {
            var requestCourses = GetRequests(new CourseRequestParamModel { RequestID = requestID });
            var query = "";
            for (int i = 0; i < requestCourses.Count; i++)
                query += "UPDATE StudentCourseRequest SET IsApproved = " + (isAccepted ? 1 : 0)
                + " WHERE RequestID = '" + requestID + "' AND CourseID = " + requestCourses.ElementAt(i).CourseID + ";";
            return QueryExecuterHelper.Execute(connectionString, query);
        }
    }
}
