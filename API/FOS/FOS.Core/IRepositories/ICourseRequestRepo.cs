using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.Core.IRepositories
{
    public interface ICourseRequestRepo
    {
        List<CourseRequestOutModel> GetRequests(CourseRequestParamModel model);
        bool DeleteRequest(string requestID, int? studentID = null);
        bool HandleRequest(string requestID, bool isAccepted);
    }
}
