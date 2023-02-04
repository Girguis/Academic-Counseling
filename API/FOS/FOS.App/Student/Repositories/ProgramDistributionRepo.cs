using FOS.Core.IRepositories.Student;
using FOS.DB.Models;

namespace FOS.App.Student.Repositories
{
    public class ProgramDistributionRepo : IProgramDistributionRepo
    {
        private readonly FOSContext context;

        public ProgramDistributionRepo(FOSContext context)
        {
            this.context = context;
        }
        public int GetAllowedHoursToRegister(int programID,int studentLevel, int passedHours, int currentSemester)
        {
            IQueryable<ProgramDistribution> programDistributions = context.ProgramDistributions.Where(x => x.ProgramId == programID);
            if (studentLevel == programDistributions.Max(x => x.Level))
                return programDistributions
                    .FirstOrDefault(x => x.Level == studentLevel && x.Semester == currentSemester)
                    .NumberOfHours;

            if (passedHours + 3 >= programDistributions.Where(x => x.Level == studentLevel + 1).Sum(x => x.NumberOfHours))
                return programDistributions.FirstOrDefault(x => x.Level == studentLevel + 1 && x.Semester == currentSemester).NumberOfHours;
            else
                return programDistributions.FirstOrDefault(x => x.Level == studentLevel && x.Semester == currentSemester).NumberOfHours;
        }
    }
}
