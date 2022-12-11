using FOS.Core.IRepositories.Student;
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

        public DB.Models.Student Get(string GUID)
        {
            return context.Students.Include("Supervisor").FirstOrDefault(x => x.Guid == GUID);
        }

        public Program GetCurrentProgram(string GUID)
        {
            return context.StudentPrograms
                .Where(x => x.Student.Guid == GUID)
                .OrderBy(x => x.AcademicYear)
                .Include(x => x.Program)
                .Select(x => x.Program)
                .LastOrDefault();
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
    }
}
