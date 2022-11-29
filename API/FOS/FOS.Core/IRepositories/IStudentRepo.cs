using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentRepo
    {
        bool Add(Student student);
        bool Delete(string GUID);
        bool Update(Student student);
        Student Login(string email,string hashedPassword);
        Student Get(String GUID);
        IQueryable<Student> GetAll();
    }
}
