using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentCoursesRepo
    {
        List<StudentCourse> GetAllCourses(int studentID);
        List<StudentCourse> GetCoursesByAcademicYear(int studentID, short academicYearID);
        List<StudentCourse> GetCurrentAcademicYearCourses(int studentID);
        List<ProgramCourse> GetCoursesForRegistration(int studentID);
        bool RegisterCourses(int studentID, short academicYearID, List<int> coursesID);
    }
}
