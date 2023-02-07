using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ICoursePrerequisiteRepo
    {
        bool AddPrerequisites(int courseID, List<int> prerequisiteIDs);
        bool UpdatePrerequisites(int courseID, List<int> prerequisiteIDs);
        bool DeletePrerequisites(int courseID);
        List<CoursePrerequisite> GetPrerequisites(int courseID);
    }
}
