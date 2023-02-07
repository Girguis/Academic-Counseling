using FOS.App.ExtensionMethods;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class StudentRepo : IStudentRepo
    {
        private readonly FOSContext context;

        public StudentRepo(FOSContext context)
        {
            this.context = context;
        }
        /// <summary>
        /// Method to get the academic details for a certian student
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public List<StudentCourse> GetAcademicDetails(string GUID)
        {
            return context.StudentCourses
                .Where(x => x.Student.Guid == GUID)
                .Include(x => x.AcademicYear)
                .Include(x => x.Course)
                .ToList();
        }
        /// <summary>
        /// Method to get all students from the database
        /// </summary>
        /// <param name="totalCount"></param>
        /// <param name="criteria"></param>
        /// <returns></returns>
        public List<DB.Models.Student> GetAll(out int totalCount, SearchCriteria criteria = null)
        {
            if (criteria == null)
            {
                List<DB.Models.Student> stds = context.Students?.ToList();
                totalCount = stds.Count();
                return stds;
            }
            var students = context.Students.AsQueryable();
            students = students.Search(criteria.Filters);
            students = students.Order(criteria.OrderByColumn, criteria.Ascending);
            totalCount = students.Count();
            students = students.Pageable(criteria.PageNumber, criteria.PageSize);
            return students?.ToList();
        }
        /// <summary>
        /// Method to get student program history
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public List<StudentProgram> GetPrograms(string GUID)
        {
            return context.StudentPrograms
                .Where(x => x.Student.Guid == GUID)
                .Include(x => x.Program)
                .ToList();
        }

        /// <summary>
        /// Method to get student who have 1 or more warning
        /// </summary>
        /// <param name="totalCount"></param>
        /// <param name="criteria"></param>
        /// <returns></returns>
        public List<DB.Models.Student> GetStudentsWithWarnings(out int totalCount, SearchCriteria criteria = null)
        {
            criteria.Filters ??= new List<SearchBaseModel>();
            criteria.Filters.Add(new SearchBaseModel()
            {
                Key = "WarningsNumber",
                Operator = ">",
                Value = 0
            });
            return GetAll(out totalCount, criteria)?.ToList();
        }
        /// <summary>
        /// Get number of males and females
        /// </summary>
        /// <returns></returns>
        public object GenderStatistics()
        {
            return context.Students.GroupBy(x => x.Gender).Select(x => new
            {
                x.Key,
                Count = x.Count()
            })?.ToList();
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
        public StudentProgram GetCurrentProgram(string GUID)
        {
            return context.StudentPrograms
                .Where(x => x.Student.Guid == GUID)
                .OrderBy(x => x.AcademicYear)
                .Include(x => x.Program)
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
