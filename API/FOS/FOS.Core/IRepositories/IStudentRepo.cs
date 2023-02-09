using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentRepo
    {
        List<Student> GetStudentsWithWarnings(out int totalCount, SearchCriteria criteria = null);
        List<Student> GetAll(out int totalCount, SearchCriteria criteria = null);
        Student Get(string GUID);
        List<StudentCourse> GetAcademicDetails(string GUID);
        List<StudentProgram> GetPrograms(string GUID);
        StudentProgram GetCurrentProgram(string GUID);
        object GenderStatistics();
        Student Login(string email, string hashedPassword);
        Student Add(Student student);
        Student GetBySSN(string ssn);
    }
}
