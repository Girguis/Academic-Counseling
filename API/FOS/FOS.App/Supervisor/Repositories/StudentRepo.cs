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

        public List<StudentCourse> GetAcademicDetails(string GUID)
        {
            return context.StudentCourses
                .Where(x => x.Student.Guid == GUID)
                .Include(x => x.AcademicYear)
                .Include(x => x.Course)
                .ToList();
        }
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

        public List<StudentProgram> GetPrograms(string GUID)
        {
            return context.StudentPrograms
                .Where(x => x.Student.Guid == GUID)
                .Include(x => x.Program)
                .ToList();
        }
        public StudentProgram GetCurrentProgram(string GUID)
        {
            return context.StudentPrograms
                .Include(x => x.Program)
                .LastOrDefault(x => x.Student.Guid == GUID);
        }
        public List<DB.Models.Student> GetStudentsWithWarnings(out int totalCount, SearchCriteria criteria = null)
        {
            if (criteria == null)
            {
                List<DB.Models.Student> stds = context.Students?.ToList();
                totalCount = stds.Count;
                return stds;
            }
            var students = context.Students.AsQueryable();
            criteria.Filters ??= new List<SearchBaseModel>();
            criteria.Filters.Add(new SearchBaseModel()
            {
                Key = "WarningsNumber",
                Operator = ">",
                Value = 0
            });
            students = students.Search(criteria.Filters);
            students = students.Order(criteria.OrderByColumn, criteria.Ascending);
            totalCount= students.Count();
            students = students.Pageable(criteria.PageNumber, criteria.PageSize);
            return students?.ToList();
        }
    }
}
