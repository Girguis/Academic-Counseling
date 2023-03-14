using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
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
        bool UpdateStudentCourses(List<StudentCourse> studentCourses);
        bool UpdateStudentCourses(int studentID,AcademicRecordModels model);
        Tuple<List<StudentCourse>, List<StudentCourse>, List<StudentCourse>, List<StudentCourse>> CompareStudentCourse(int studentID, List<StudentCourse> studentCourses);
        CourseGradesSheetOutModel GetStudentsMarksList(int courseID);
        ExamCommitteeStudentsOutModel GetStudentsList(ExamCommitteeStudentsParamModel model);
        bool UpdateStudentsGradesFromSheet(List<GradesSheetUpdateModel> model);
    }
}
