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
    public class CourseRequestRepo : ICourseRequestRepo
    {
        private readonly IDbContext config;

        public CourseRequestRepo(IDbContext config)
        {
            this.config = config;
        }
        public bool DeleteRequest(string requestID, int? studentID = null)
        {
            var query = "DELETE FROM StudentCourseRequest WHERE RequestID = '" + requestID + "'";
            if (studentID != null)
                query += " AND StudentID = " + studentID;
            return QueryExecuterHelper
                .Execute(config.CreateInstance(), query);
        }
        public List<CourseRequestOutModel> GetRequests(CourseRequestParamModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@RequestID", model.RequestID);
            parameters.Add("@RequestTypeID", model.RequestTypeID);
            parameters.Add("@StudentID", model.StudentID);
            parameters.Add("@IsApproved", model.IsApproved);
            var res = QueryExecuterHelper.Execute<CourseRequestOutModel>
                (config.CreateInstance(),
                "GetCoursesRequests",
                parameters);
            for (int i = 0; i < res.Count; i++)
            {
                res.ElementAt(i).CourseOperation = res.ElementAt(i).CourseOperationID ? Helper.GetDisplayName(CourseOperationEnum.Addtion) : Helper.GetDisplayName(CourseOperationEnum.Deletion);
                res.ElementAt(i).RequestType = Helper.GetDisplayName((CourseRequestEnum)res.ElementAt(i).RequestTypeID);
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
            return QueryExecuterHelper.Execute(config.CreateInstance(), query);
        }
    }
}
