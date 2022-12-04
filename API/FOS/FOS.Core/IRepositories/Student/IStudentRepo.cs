using FOS.Core.SearchModels;

namespace FOS.Core.IRepositories.Student
{
    public interface IStudentRepo
    {
        bool Add(DB.Models.Student student);
        bool Delete(string GUID);
        bool Update(DB.Models.Student student);
        DB.Models.Student Login(string email, string hashedPassword);
        DB.Models.Student Get(string GUID);
        List<DB.Models.Student> GetAll(StudentSearchCriteria criteria = null);
    }
}
