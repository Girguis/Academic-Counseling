using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IAcademicYearRepo
    {
        bool StartNewYear();
        AcademicYear GetCurrentYear();
        List<AcademicYear> GetAcademicYearsList();
        List<AcademicYear> GetAll(int studentID);
        double? GetAcademicYearGPA(int studentID, short academicYear);
    }
}
