using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ICoursePrerequisiteRepo
    {
        bool AddPrerequisites(int courseID,int programID, List<int> prerequisiteIDs);
        bool UpdatePrerequisites(int courseID, int programID, List<int> prerequisiteIDs);
        bool DeletePrerequisites(int courseID, int programID);
        List<CoursePrerequisite> GetPrerequisites(int courseID, int programID);
    }
}
