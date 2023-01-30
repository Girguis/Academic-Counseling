using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

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
        /// <summary>
        /// Method to get courses that student can register
        /// </summary>
        /// <param name="studentID"></param>
        /// <returns></returns>
        public List<ProgramCourse> GetCoursesForRegistration(int studentID)
        {
            var studentIDParam = new SqlParameter("@StudentID", studentID);
            var res = context.ProgramCourses.FromSqlRaw("exec GetAvailableCoursesToRegister @StudentID",
                                    studentIDParam).ToList();
            var res2 = context.Courses.FromSqlRaw("exec GetAvailableCoursesToRegister @StudentID",
                                    studentIDParam).ToList();
            for (int i = 0; i < res.Count(); i++)
                res.ElementAt(i).Course = res2.ElementAt(i);
            return res;
        }
        public bool RegisterCourses(int studentID,short academicYearID ,List<int> courseIDs)
        {
            var studentIdParam = new SqlParameter("@StudentID", studentID);
            var dt = new DataTable();
            dt.Columns.Add("CourseID");
            for (var i = 0; i < courseIDs.Count; i++)
                dt.Rows.Add(courseIDs[i]);
            var CourseIDsParam = new SqlParameter("@CourseIDs", dt);
            CourseIDsParam.SqlDbType = SqlDbType.Structured;
            CourseIDsParam.TypeName = "[dbo].[StudentRegistrationCoursesType]";
            var academicYearParam = new SqlParameter("@CurrentAcademicYearID", academicYearID);
            return context.Database.ExecuteSqlRaw("EXEC [dbo].[RegisterCoursesForStudent] @StudentID, @CourseIDs, @CurrentAcademicYearID", studentIdParam, CourseIDsParam, academicYearParam) > 0;
        }
    }
}
