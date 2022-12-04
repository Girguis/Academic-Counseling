using FOS.App.ExtensionMethods;
using FOS.Core.IRepositories.Student;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Student.Repositories
{
    public class StudentRepo : IStudentRepo
    {
        private readonly FOSContext context;

        public StudentRepo(FOSContext entity)
        {
            context = entity;
        }
        private bool Save()
        {
            return context.SaveChanges() > 0;
        }

        public bool Add(DB.Models.Student student)
        {
            context.Students.Add(student);
            return Save();
        }

        public bool Delete(string GUID)
        {
            DB.Models.Student student = Get(GUID);
            if (student == null)
                return false;
            context.Students.Remove(student);
            return Save();
        }

        public DB.Models.Student Get(string GUID)
        {
            return context.Students.Include("Supervisor").FirstOrDefault(x => x.Guid == GUID);
            //return _Entities.DB.Models.Students.FirstOrDefault(x => x.Guid == GUID);
        }

        public List<DB.Models.Student> GetAll(StudentSearchCriteria criteria = null)
        {
            if (criteria == null)
                return context.Students?.ToList();

            var students = context.Students.AsQueryable();
            var s2 = students.Search(criteria.Filters).ToList();

            //if (!string.IsNullOrWhiteSpace(criteria.FirstName))
            //    DB.Models.Students = DB.Models.Students.Where(s => s.Fname.Contains(criteria.FirstName));

            //if (!string.IsNullOrWhiteSpace(criteria.MiddleName))
            //    DB.Models.Students = DB.Models.Students.Where(s => s.Mname.Contains(criteria.MiddleName));

            //if (!string.IsNullOrWhiteSpace(criteria.LastName))
            //    DB.Models.Students = DB.Models.Students.Where(s => s.Lname.Contains(criteria.LastName));

            //if (criteria.WarningsCount.HasValue)
            //{
            //    if(criteria.WarningsCountOp==">")
            //    {
            //        DB.Models.Students = DB.Models.Students.Where(x => x.WarningsNumber > criteria.WarningsCount);
            //    }
            //}
            students = students.Order(criteria.OrderByColumn, criteria.Ascending);
            return students?.ToList();
        }




        public bool Update(DB.Models.Student student)
        {
            context.Entry(student).State = EntityState.Modified;
            return Save();
        }

        public DB.Models.Student Login(string email, string hashedPassword)
        {
            //var emailParam = new SqlParameter("@Email", email);
            //var passwordParam = new SqlParameter("@Password", hashedPassword);  
            //return context.Students.FromSqlRaw("exec SP_DB.Models.StudentLogin @Email,@Password", emailParam, passwordParam).ToList().FirstOrDefault();
            return context.Students.FirstOrDefault(x => x.Email == email & x.Password == hashedPassword);
        }

        public IQueryable<DB.Models.Student> GetAll()
        {
            throw new NotImplementedException();
        }
    }
}
