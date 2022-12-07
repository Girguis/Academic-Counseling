using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories.Supervisor
{
    public interface IStudentRepo
    {
        List<DB.Models.Student> GetStudentsWithWarnings(out int totalCount, SearchCriteria criteria = null);
        List<DB.Models.Student> GetAll(out int totalCount, SearchCriteria criteria = null);
        DB.Models.Student Get(string GUID);
        List<DB.Models.StudentCourse> GetAcademicDetails(string GUID);
        List<StudentProgram> GetPrograms(string GUID);
        StudentProgram GetCurrentProgram(string GUID);
    }
}
