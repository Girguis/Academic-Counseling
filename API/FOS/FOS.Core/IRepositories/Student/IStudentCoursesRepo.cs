using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IStudentCoursesRepo
    {
        List<StudentCourse> GetAllCourses(int studentID);
        List<StudentCourse> GetCoursesByAcademicYear(int studentID, short academicYearID);
        List<StudentCourse> GetCurrentAcademicYearCourses(int studentID);
    }
}
