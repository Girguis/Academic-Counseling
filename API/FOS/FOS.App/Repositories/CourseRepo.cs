using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

namespace FOS.App.Repositories
{
    public class CourseRepo : ICourseRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public CourseRepo(FOSContext context, IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }
        public bool Add(List<Course> courses)
        {
            context.Courses.AddRange(courses);
            return context.SaveChanges() > 0;
        }
        public bool Delete(Course course)
        {
            if (
                context.StudentCourses.Any(x => x.CourseId == course.Id)
                || context.ProgramCourses.Any(x => x.CourseId == course.Id)
                || context.TeacherCourses.Any(x => x.CourseId == course.Id)
                ) return false;

            context.Courses.Remove(course);
            return context.SaveChanges() > 0;
        }
        public List<Course> GetAll(out int totalCount, SearchCriteria criteria = null)
        {
            DbSet<Course> courses = context.Courses;
            return DataFilter<Course>.FilterData(courses, criteria, out totalCount);
        }
        public List<Course> GetAll()
        {
            return context.Courses.AsNoTracking().AsParallel().ToList();
        }
        public Course GetById(int id)
        {
            return context.Courses.FirstOrDefault(x => x.Id == id);
        }
        public bool Update(Course course)
        {
            if (course == null) return false;
            context.Entry(course).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
        public bool Activate(List<int> courseIDs)
        {
            string courseLst = string.Concat("(", string.Join(",", courseIDs), ")");
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IsActive", true),
                new SqlParameter("@CourseLst", courseLst)
            };
            return QueryHelper.Execute(connectionString, "CoursesActivation", parameters);
        }
        public bool Deactivate(List<int> courseIDs)
        {
            string courseLst = string.Concat("(", string.Join(",", courseIDs), ")");
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IsActive",false),
                new SqlParameter("@CourseLst", courseLst)
            };
            return QueryHelper.Execute(connectionString, "CoursesActivation", parameters);
        }
    }
}