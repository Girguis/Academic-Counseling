using FOS.App.Comparers;
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
        public IEnumerable<StudentCourse> GetAllCourses(int studentID)
        {
            return context.StudentCourses.Where(x => x.StudentId == studentID);
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
        public bool RegisterCourses(int studentID, short academicYearID, List<int> courses)
        {
            var connectionString = configuration["ConnectionStrings:FosDB"];
            var insertStatement = "INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGPAIncluded,IsIncluded) VALUES ({0},{1},{2},{3},{4},{5});";
            string query = "";
            for (int i = 0; i < courses.Count; i++)
            {
                query += string.Format(insertStatement, studentID, courses.ElementAt(i), academicYearID, 1, 1, 1);
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
        public bool AddStudentCourses(List<StudentCourse> studentCourses)
        {
            int studentID = studentCourses.ElementAt(0).StudentId;
            var savedCoursesLst = GetAllCourses(studentID);
            StudentCoursesComparer coursesComparer = new StudentCoursesComparer();
            IEnumerable<StudentCourse> toBeSavedLst = studentCourses.Except(savedCoursesLst, coursesComparer);
            if (!toBeSavedLst.Any())
                return true;

            var connectionString = configuration["ConnectionStrings:FosDB"];
            string query = "";
            for (int i = 0; i < toBeSavedLst.Count(); i++)
            {
                var course = toBeSavedLst.ElementAt(i);
                if (course.HasExecuse == true)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsIncluded,HasExecuse,IsGpaIncluded) VALUES({0},{1},{2},{3},{4},{5},{6});",
                        course.StudentId, course.CourseId, course.AcademicYearId, 1, 1, 1, 0);
                }
                else if (course.IsGpaincluded == false && course.Mark == null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsIncluded,IsGpaIncluded,Grade) VALUES({0},{1},{2},{3},{4},{5},'{6}');",
                        course.StudentId, course.CourseId, course.AcademicYearId,1,1,0,course.Grade.Trim());
                }
                else if (course.IsGpaincluded == false && course.Mark != null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsIncluded,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5},{6});",course.StudentId,course.CourseId,course.AcademicYearId,1,1,0,course.Mark);
                }
                else
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsIncluded,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5},{6});",
                            course.StudentId, course.CourseId, course.AcademicYearId, 1, 1, 1, course.Mark);
                }
            }
            int res = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("[dbo].[QueryExecuter]", con);
                var queryParam = new SqlParameter("@Query", query);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(queryParam);
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