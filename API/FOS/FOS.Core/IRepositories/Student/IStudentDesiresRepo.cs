using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IStudentDesiresRepo
    {
        bool Add(StudentDesire studentDesires);
        bool Update(StudentDesire studentDesires);
        IQueryable<StudentDesire> Get(string guid);
        IQueryable<StudentDesire> GetAll();
        bool DeleteAllRecords();
    }
}
