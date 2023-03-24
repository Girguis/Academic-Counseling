using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Extensions.Configuration;

namespace FOS.App.Repositories
{
    public class ProgramDistributionRepo : IProgramDistributionRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;

        public ProgramDistributionRepo(FOSContext context,IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
        }
        public int GetAllowedHoursToRegister(int programID, int studentLevel, int passedHours, int currentSemester)
        {
            IQueryable<ProgramDistribution> programDistributions = context.ProgramDistributions.Where(x => x.ProgramId == programID);
            if (studentLevel == programDistributions.Max(x => x.Level))
            {
                var obj = programDistributions
                    .FirstOrDefault(x => x.Level == studentLevel && x.Semester == currentSemester);
                if (obj == null)
                    return 12;

                return obj.NumberOfHours;
            }
            bool parsed = int.TryParse(configuration["HoursToSkip"], out int hoursToSkip);
            if (!parsed) hoursToSkip = 3;
            if (passedHours + hoursToSkip >= programDistributions.Where(x => x.Level == studentLevel + 1).Sum(x => x.NumberOfHours))
                return programDistributions.FirstOrDefault(x => x.Level == studentLevel + 1 && x.Semester == currentSemester).NumberOfHours;
            else
                return programDistributions.FirstOrDefault(x => x.Level == studentLevel && x.Semester == currentSemester).NumberOfHours;
        }
    }
}
