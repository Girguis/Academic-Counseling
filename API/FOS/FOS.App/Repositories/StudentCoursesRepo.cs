using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class StudentCoursesRepo : IStudentCoursesRepo
    {
        private readonly FOSContext context;
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IConfiguration configuration;

        public StudentCoursesRepo(FOSContext context, IAcademicYearRepo academicYearRepo, IConfiguration configuration)
        {
            this.context = context;
            this.academicYearRepo = academicYearRepo;
            this.configuration = configuration;
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
        public bool RegisterCourses(int studentID, short academicYearID, List<int> courseIDs)
        {
            var connectionString = configuration["ConnectionStrings:FosDB"];
            var insertStatement = "INSERT INTO StudentCourses(StudentID, CourseID,AcademicYearID,IsApproved,IsGPAIncluded,IsIncluded) VALUES ({0},{1},{2},{3},{4},{5});";
            string query = "";
            for (int i = 0; i < courseIDs.Count; i++)
            {
                query += string.Format(insertStatement, studentID, courseIDs.ElementAt(i), academicYearID, 1, 1, 1);
            }
            var queryParam = new SqlParameter("@Query", query);
            var studentIdParam = new SqlParameter("@StudentID", studentID);
            var academicYearParam = new SqlParameter("@CurrentAcademicYearID", academicYearID);
            int res = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("[dbo].[RegisterCoursesForStudent]", con);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(queryParam);
                cmd.Parameters.Add(studentIdParam);
                cmd.Parameters.Add(academicYearParam);
                SqlTransaction trans1 = con.BeginTransaction();
                cmd.Transaction = trans1;
                try
                {
                    res = cmd.ExecuteNonQuery();
                    trans1.Commit();
                }
                catch
                {
                    trans1.Rollback();
                }
                con.Close();
            }
            return res > 0;
        }
    }
}
