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
        /// <summary>
        /// Method used to retrive student record from Student table by GUID
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public DB.Models.Student Get(string GUID)
        {
            return context.Students.Include("Supervisor").FirstOrDefault(x => x.Guid == GUID);
        }
        /// <summary>
        /// Method used to get student current program
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public Program GetCurrentProgram(string GUID)
        {
            return context.StudentPrograms
                .Where(x => x.Student.Guid == GUID)
                .OrderBy(x => x.AcademicYear)
                .Include(x => x.Program)
                .Select(x => x.Program)
                .LastOrDefault();
        }
        /// <summary>
        /// Method used to get student with provided E-mail and password
        /// returns null if E-mail or password are invalid
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public DB.Models.Student Login(string email, string hashedPassword)
        {
            //var emailParam = new SqlParameter("@Email", email);
            //var passwordParam = new SqlParameter("@Password", hashedPassword);  
            //return context.Students.FromSqlRaw("exec SP_DB.Models.StudentLogin @Email,@Password", emailParam, passwordParam).ToList().FirstOrDefault();
            return context.Students.FirstOrDefault(x => x.Email == email & x.Password == hashedPassword);
        }
    }
}
