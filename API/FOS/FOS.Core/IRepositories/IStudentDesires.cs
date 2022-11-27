using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentDesires
    {
        bool Add(StudentDesire studentDesires);
        bool Update(StudentDesire studentDesires);
        IQueryable<StudentDesire> Get(string guid);
        IQueryable<StudentDesire> GetAll();
        bool DeleteAllRecords();
    }
}
