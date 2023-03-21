using FOS.App.Students.DTOs;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentCoursesRepo
    {
        IEnumerable<StudentCourse> GetAllCourses(int studentID);
        List<StudentCoursesOutModel> GetCoursesByAcademicYear(int studentID, short academicYearID);
        List<StudentCoursesOutModel> GetCurrentAcademicYearCourses(int studentID);
        List<CourseRegistrationOutModel> GetCoursesForRegistration(int studentID);
        (List<CourseRegistrationOutModel> toAdd,
            List<CourseRegistrationOutModel> toDelete,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForAddAndDelete(int studentID);
        List<CourseRegistrationOutModel> GetCoursesForWithdraw(int studentID);
        (List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForEnhancement(int studentID);
        (List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForGraduation(int studentID);
        (int RegisteredHours, List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForOverload(int studentID);
        bool RegisterCourses(int studentID, short academicYearID, List<int> courseIDs);
        bool UpdateStudentCourses(List<StudentCourse> studentCourses);
        bool UpdateStudentCourses(int studentID, AcademicRecordModels model);
        Tuple<List<StudentCourse>, List<StudentCourse>, List<StudentCourse>, List<StudentCourse>> CompareStudentCourse(int studentID, List<StudentCourse> studentCourses);
        CourseGradesSheetOutModel GetStudentsMarksList(int courseID);
        ExamCommitteeStudentsOutModel GetStudentsList(ExamCommitteeStudentsParamModel model);
        bool UpdateStudentsGradesFromSheet(List<GradesSheetUpdateModel> model);
        bool RequestAddAndDelete(int studentID, AddAndDeleteCoursesParamModel model);
        bool RequestCourse(int requestType, int studentID, CoursesLstParamModel model);
    }
}
