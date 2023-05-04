using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.Configs;
using FOS.Core.IRepositories;
using FOS.DB.Models;

namespace FOS.App.Repositories
{
    public class ProgramDistributionRepo : IProgramDistributionRepo
    {
        private readonly IDbContext config;

        public ProgramDistributionRepo(IDbContext config)
        {
            this.config = config;
        }
        public int? GetAllowedHoursToRegister(int programID, int studentLevel, int passedHours, int currentSemester)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Query", "SELECT * FROM ProgramDistribution WHERE ProgramID=" + programID);
            var programDistributions =
                QueryExecuterHelper.Execute<ProgramDistribution>
                        (config.CreateInstance(),
                        "QueryExecuter",
                        parameters);
            if (programDistributions == null || programDistributions.Count < 1)
                return null;
            if (studentLevel == programDistributions.Max(x => x.Level))
            {
                var obj = programDistributions
                    .FirstOrDefault(x => x.Level == studentLevel && x.Semester == currentSemester);
                if (obj == null)
                    return 12;

                return obj.NumberOfHours;
            }
            int hoursToSkip = ConfigurationsManager.TryGetNumber(Config.HoursToSkip, 3);
            if (passedHours + hoursToSkip >= programDistributions.Where(x => x.Level == studentLevel + 1)?.Sum(x => x.NumberOfHours))
                return programDistributions.FirstOrDefault(x => x.Level == studentLevel + 1 && x.Semester == currentSemester)?.NumberOfHours;
            else
                return programDistributions.FirstOrDefault(x => x.Level == studentLevel && x.Semester == currentSemester)?.NumberOfHours;
        }
    }
}
