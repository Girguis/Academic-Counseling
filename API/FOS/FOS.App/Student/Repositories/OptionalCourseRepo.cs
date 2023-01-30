using FOS.Core.IRepositories.Student;
using FOS.DB.Models;

namespace FOS.App.Student.Repositories
{
    public class OptionalCourseRepo : IOptionalCourseRepo
    {
        private readonly FOSContext context;

        public OptionalCourseRepo(FOSContext context)
        {
            this.context = context;
        }
        public List<OptionalCourse> GetOptionalCoursesDistibution(int programID)
        {
            return context.OptionalCourses.Where(x => x.ProgramId == programID).ToList();
        }
    }
}
