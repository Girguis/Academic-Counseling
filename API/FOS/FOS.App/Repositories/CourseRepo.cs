using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class CourseRepo : ICourseRepo
    {
        private readonly FOSContext context;
        public CourseRepo(FOSContext context)
        {
            this.context = context;
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
    }
}