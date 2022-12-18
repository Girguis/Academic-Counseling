using FOS.App.ExtensionMethods;
using FOS.Core.IRepositories.Supervisor;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Supervisor.Repositories
{
    public class StudentRepo : IStudentRepo
    {
        private readonly FOSContext context;

        public StudentRepo(FOSContext context)
        {
            this.context = context;
        }
        public DB.Models.Student Get(string GUID)
        {
            return context.Students.FirstOrDefault(x => x.Guid == GUID);
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
        public List<DB.Models.Student> GetAll(out int totalCount,SearchCriteria criteria = null)
        {
            if (criteria == null)
            {
                List<DB.Models.Student> stds = context.Students?.ToList();
                totalCount = stds.Count();
                return stds ;
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
        /// Method to get student program's details
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public StudentProgram GetCurrentProgram(string GUID)
        {
            return context.StudentPrograms
                .Include(x => x.Program)
                .LastOrDefault(x => x.Student.Guid == GUID);
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
    }
}
