using FOS.Core.Models;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentCoursesRepo
    {
        IEnumerable<StudentCourse> GetAllCourses(int studentID);
        List<StudentCourse> GetCoursesByAcademicYear(int studentID, short academicYearID);
        List<StudentCourse> GetCurrentAcademicYearCourses(int studentID);
        List<ProgramCourse> GetCoursesForRegistration(int studentID);
        bool RegisterCourses(int studentID, short academicYearID, List<int> courseIDs);
        bool AddStudentCourses(List<StudentCourse> studentCourses);
        List<StudentCourse> GetStudentsList(int courseID, short academicYearID);
        bool UpdateStudentsGradesFromSheet(List<GradesSheetUpdateModel> model);
    }
}
