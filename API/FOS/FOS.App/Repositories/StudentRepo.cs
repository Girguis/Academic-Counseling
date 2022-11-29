using FOS.Core.IRepositories;
using FOS.DB.Models;
using System.Security.Cryptography.X509Certificates;

namespace FOS.App.Repositories
{
    public class StudentRepo : IStudentRepo
    {
        private readonly FOSContext _Entities;

        public StudentRepo(FOSContext entity)
        {
            _Entities = entity;
        }
        private bool Save()
        {
            return _Entities.SaveChanges() > 0;
        }

        public bool Add(Student student)
        {
            _Entities.Students.Add(student);
            return Save();
        }

        public bool Delete(string GUID)
        {
            Student student = Get(GUID);
            if (student == null)
                return false;
            _Entities.Students.Remove(student);
            return Save();
        }

        public Student Get(string GUID)
        {
            return _Entities.Students.FirstOrDefault(x => x.Guid == GUID);
        }

        public IQueryable<Student> GetAll()
        {
            return _Entities.Students;
        }

        public bool Update(Student student)
        {
            _Entities.Entry(student).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
            return Save();
        }

        public Student Login(string email, string hashedPassword)
        {
            return _Entities.Students.FirstOrDefault(x=>x.Email == email & x.Password ==hashedPassword);
        }
    }
}
