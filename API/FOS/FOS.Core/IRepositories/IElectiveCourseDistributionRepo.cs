using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IElectiveCourseDistributionRepo
    {
        List<ElectiveCourseDistribution> GetOptionalCoursesDistibution
            (int studentID,
            bool isForOverload = false,
            bool isForEnhancement = false);
    }
}
