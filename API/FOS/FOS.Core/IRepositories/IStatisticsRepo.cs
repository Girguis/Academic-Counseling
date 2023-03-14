using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.Core.IRepositories
{
    public interface IStatisticsRepo
    {
        List<StatisticsOutModel> GetStudentsGradesStatistics(StudentsGradesParatmeterModel model);
        List<StatisticsOutModel> GetProgramsStatistics();
        List<StatisticsOutModel> GetGendersStatistics();
        List<StatisticsOutModel> GetCourseStatistics(CourseStatisticsParameterModel model);
    }
}
