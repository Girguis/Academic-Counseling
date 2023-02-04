using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IElectiveCourseDistributionRepo
    {
        List<ElectiveCourseDistribution> GetOptionalCoursesDistibution(int programID);
    }
}
