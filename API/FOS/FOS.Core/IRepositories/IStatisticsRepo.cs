using FOS.Core.Models;

namespace FOS.Core.IRepositories
{
    public interface IStatisticsRepo
    {
        List<StatisticsModel> GetStudentsGradesStatistics(StudentsGradesParatmeterModel model);
        List<StatisticsModel> GetProgramsStatistics();
        List<StatisticsModel> GetGendersStatistics();
    }
}
