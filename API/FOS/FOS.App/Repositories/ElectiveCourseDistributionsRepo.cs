using FOS.Core.IRepositories;
using FOS.DB.Models;

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
    }
}
