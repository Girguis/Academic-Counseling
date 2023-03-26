using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Extensions.Configuration;

namespace FOS.App.Repositories
{
    public class ProgramDistributionRepo : IProgramDistributionRepo
    {
        private readonly IConfiguration configuration;
        private readonly IDbContext config;

        public ProgramDistributionRepo(IConfiguration configuration, IDbContext config)
        {
            this.configuration = configuration;
            this.config = config;
        }
        public int GetAllowedHoursToRegister(int programID, int studentLevel, int passedHours, int currentSemester)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Query", "SELECT * FROM ProgramDistribution WHERE ProgramID=" + programID);
            var programDistributions =
                QueryExecuterHelper.Execute<ProgramDistribution>
                        (config.CreateInstance(),
                        "QueryExecuter",
                        parameters);
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
