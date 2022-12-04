using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IAcademicYearRepo
    {
        List<AcademicYear> GetAll(int studentID);
        AcademicYear GetCurrentYear();
        double? GetAcademicYearGPA(int studentID,short academicYear);
    }
}
