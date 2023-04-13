using FOS.Core.Models;
using FOS.Core.Models.DTOs;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using FOS.Core.StudentDTOs;
using FOS.DB.Models;
using System.Data;

namespace FOS.Core.IRepositories
{
    public interface IStudentRepo
    {
        Student Get(string GUID, bool includeProgram = false, bool includeSupervisor = false);
        (int totalCount, List<StudentsDTO> students) GetAll(SearchCriteria criteria, int? DoctorProgramID = null);
        StudentAcademicReportDTO GetAcademicDetails(Student student);
        (List<AcademicYearsDTO> academicYears
            ,List<StudentCoursesGradesOutModel> courses) 
            GetAcademicDetailsForReport(int studentID);
        Student Login(string email, string hashedPassword);
        Student Add(Student student);
        bool Add(DataTable dataTable);
        Student GetBySSN(string ssn);
        bool Update(Student student);
        bool ChangePassword(int id,string password);
        bool Deactivate(string guid);
        bool Activate(string guid);
        StudentCoursesSummaryOutModel GetStudentCoursesSummary(int studentID);
        StudentCoursesSummaryTreeOutModel GetStudentCoursesSummaryTree(int studentID);
        List<StruggledStudentsOutModel> GetStruggledStudents(StruggledStudentsParamModel model);
        List<AcademicYearsDTO> GetStudentAcademicYearsSummary(int studentID);
        float GetLastRegularSemesterGPA(int studentID);
        bool CanOpenCourseForGraduation(int studentID, byte passedHours, int programID, int hoursToSkip);
        List<GetReportByCgpaOutModel> ReportByCgpa(GetReportByCgpaParamModel model);
    }
}
