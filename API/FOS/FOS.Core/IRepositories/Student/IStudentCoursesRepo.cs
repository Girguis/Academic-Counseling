using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IStudentCoursesRepo
    {
        bool Add(StudentCourse studentCourse);
        bool Update(StudentCourse studentCourse);
        bool Delete(StudentCourse studentCourse);
        List<StudentCourse> GetAllCourses(int studentID);
        List<StudentCourse> GetCoursesByAcademicYear(int studentID, short academicYearID);
        List<StudentCourse> GetCurrentAcademicYearCourses(int studentID);
        IQueryable<StudentCourse> GetAll();
    }
}
