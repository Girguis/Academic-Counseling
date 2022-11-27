using FOS.Core.IRepositories;
using FOS.DB.Models;

namespace FOS.App.Repositories
{
    public class StudentDesires : IStudentDesires
    {
        private readonly FOSContext _Entites;

        public StudentDesires() { }
        public StudentDesires(FOSContext entites)
        {
            _Entites = entites;
        }
        private bool Save()
        {
            return _Entites.SaveChanges() > 0;
        }
        public bool Add(List<StudentDesire> studentDesires)
        {
            _Entites.StudentDesires.AddRange(studentDesires);
            return Save();
        }


        public IQueryable<StudentDesire> Get(string guid)
        {
            return from s in _Entites.StudentDesires
                   where s.Student.Guid == guid
                   select new StudentDesire
                   {
                       StudentId = s.StudentId,
                       DesireNumber = s.DesireNumber,
                       ProgramId = s.ProgramId
                   };
        }

        public bool Update(List<StudentDesire> studentDesires)
        {
            foreach (var studentDesire in studentDesires)
            {
                //  _Entites.StudentDesires.AddOrUpdate(studentDesire);
            }
            return Save();
        }

        public bool DeleteAllRecords()
        {
            _Entites.StudentDesires.RemoveRange(GetAll());
            return Save();
        }

        public IQueryable<StudentDesire> GetAll()
        {
            return _Entites.StudentDesires;
        }

        public bool Add(StudentDesire studentDesires)
        {
            throw new NotImplementedException();
        }

        public bool Update(StudentDesire studentDesires)
        {
            throw new NotImplementedException();
        }
    }
}
