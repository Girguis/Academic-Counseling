using FOS.Core.Models.DTOs;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentRepo
    {
        List<Student> GetStudentsWithWarnings(out int totalCount, SearchCriteria criteria = null);
        List<Student> GetAll(out int totalCount, SearchCriteria criteria = null, bool includeProgram = true);
        Student Get(string GUID, bool includeProgram = false, bool includeSupervisor = false);
        (int totalCount, List<StudentsDTO> students) GetAll(SearchCriteria criteria, int? DoctorProgramID = null);
        List<StudentCourse> GetAcademicDetails(string GUID);
        List<StudentProgram> GetPrograms(string GUID);
        StudentProgram GetCurrentProgram(string GUID);
        Student Login(string email, string hashedPassword);
        Student Add(Student student);
        Student GetBySSN(string ssn);
        bool Update(Student student);
        bool Deactivate(string guid);
        bool Activate(string guid);
        StudentCoursesSummaryOutModel GetStudentCoursesSummary(int studentID);
        List<StruggledStudentsOutModel> GetStruggledStudents(StruggledStudentsParamModel model);
    }
}
