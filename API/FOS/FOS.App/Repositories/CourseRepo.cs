using FOS.App.ExtensionMethods;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class CourseRepo : ICourseRepo
    {
        private readonly FOSContext context;
        private readonly ICoursePrerequisiteRepo coursePrerequisiteRepo;

        public CourseRepo(FOSContext context,ICoursePrerequisiteRepo coursePrerequisiteRepo)
        {
            this.context = context;
            this.coursePrerequisiteRepo = coursePrerequisiteRepo;
        }
        public Course Add(Course course)
        {
            var c = context.Courses.Add(course);
            var res = context.SaveChanges();
            if (res > 0)
                return c.Entity;
            return null;
        }
        public bool Delete(Course course)
        {
            if (
                context.StudentCourses.Any(x => x.CourseId == course.Id)
                || context.ProgramCourses.Any(x => x.CourseId == course.Id)
                || context.TeacherCourses.Any(x => x.CourseId == course.Id)
                ) return false;
            if(coursePrerequisiteRepo.DeletePrerequisites(course.Id))
            {
                context.Remove(course);
                return context.SaveChanges() > 0;
            }
            return false;
        }
        public List<Course> GetAll(out int totalCount, SearchCriteria criteria = null)
        {
            if (criteria == null)
            {
                var res = context.Courses?.ToList();
                totalCount = res.Count;
                return res;
            }
            var courses = context.Courses.AsQueryable();
            courses = courses.Search(criteria.Filters);
            courses = courses.Order(criteria.OrderByColumn, criteria.Ascending);
            totalCount = courses.Count();
            courses = courses.Pageable(criteria.PageNumber, criteria.PageSize);
            return courses?.ToList();
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