using FOS.DB.Models;

namespace FOS.Core.IRepositories.Supervisor
{
    public interface IAcademicYearRepo
    {
        bool StartNewYear();
        AcademicYear GetCurrentYear();
        List<AcademicYear> GetAcademicYearsList();
    }
}
