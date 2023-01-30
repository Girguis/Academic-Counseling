using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IOptionalCourseRepo
    {
        List<OptionalCourse> GetOptionalCoursesDistibution(int programID);
    }
}
