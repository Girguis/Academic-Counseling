using FOS.DB.Models;

namespace FOS.Core.IRepositories.Doctor
{
    public interface IAcademicYearRepo
    {
        bool StartNewYear();
        AcademicYear GetCurrentYear();
        List<AcademicYear> GetAcademicYearsList();
    }
}
