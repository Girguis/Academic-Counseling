using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Student.Repositories
{
    public class StudentCoursesRepo : IStudentCoursesRepo
    {
        private readonly FOSContext context;
        private readonly IAcademicYearRepo academicYearRepo;

        public StudentCoursesRepo(FOSContext context, IAcademicYearRepo academicYearRepo)
        {
            this.context = context;
            this.academicYearRepo = academicYearRepo;
        }
        /// <summary>
        /// Method to get all courses for a certain student
        /// </summary>
        /// <param name="studentID"></param>
        /// <returns></returns>
        public List<StudentCourse> GetAllCourses(int studentID)
        {
            IQueryable<StudentCourse> coursesList = context.StudentCourses.Where(x => x.StudentId == studentID).Include("Course");
            return coursesList.ToList();
        }
        /// <summary>
        /// Method to get all courses for a certain student for the current year
        /// </summary>
        /// <param name="studentID"></param>
        /// <returns></returns>
        public List<StudentCourse> GetCurrentAcademicYearCourses(int studentID)
        {
             return GetCoursesByAcademicYear(studentID, academicYearRepo.GetCurrentYear().Id).ToList();
        }
        /// <summary>
        /// Method to get all courses for a certain student in any academic year
        /// </summary>
        /// <param name="studentID"></param>
        /// <param name="academicYearID"></param>
        /// <returns></returns>
        public List<StudentCourse> GetCoursesByAcademicYear(int studentID, short academicYearID)
        {
            IQueryable<StudentCourse> courses = context.StudentCourses
                .Where(x => x.StudentId == studentID & x.AcademicYearId == academicYearID)
                .Include("Course");
            return courses.ToList();
        }
    }
}
