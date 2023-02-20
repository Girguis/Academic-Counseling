using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IElectiveCourseDistributionRepo
    {
        List<ElectiveCourseDistribution> GetOptionalCoursesDistibution(int programID);
        List<ElectiveCourseDistribution> GetOptionalCoursesDistibution(int programID,int studentID);
    }
}
