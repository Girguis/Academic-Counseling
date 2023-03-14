using Dapper;
using FOS.App.Comparers;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
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
        private readonly string connectionString;

        public StudentCoursesRepo(FOSContext context, IAcademicYearRepo academicYearRepo, IConfiguration configuration)
        {
            this.context = context;
            this.academicYearRepo = academicYearRepo;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }
        /// <summary>
        /// Method to get all courses for a certain student
        /// </summary>
        /// <param name="studentID"></param>
        /// <returns></returns>
        public IEnumerable<StudentCourse> GetAllCourses(int studentID)
        {
            return context.StudentCourses.Where(x => x.StudentId == studentID).Include(x => x.Course).AsNoTracking().AsParallel();
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
            var parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            using SqlConnection con = new SqlConnection(connectionString);
            var programCourses =
                con.Query<ProgramCourse, Course, ProgramCourse>
                ("GetAvailableCoursesToRegister",
                (program, course) =>
                {
                    program.Course = course;
                    return program;
                },
                param: parameters,
                splitOn: "ID",
                commandType: CommandType.StoredProcedure);

            return programCourses?.ToList();
        }
        public bool RegisterCourses(int studentID, short academicYearID, List<int> courses)
        {
            var insertStatement = "INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGPAIncluded) VALUES ({0},{1},{2},{3},{4});";
            string query = "";
            for (int i = 0; i < courses.Count; i++)
            {
                query += string.Format(insertStatement, studentID, courses.ElementAt(i), academicYearID, 1, 1);
            }
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@Query", query),
                new SqlParameter("@StudentID", studentID),
                new SqlParameter("@CurrentAcademicYearID", academicYearID)
            };
            return QueryHelper.Execute(connectionString, "StudentCoursesRegistration", parameters);
        }

        public Tuple<List<StudentCourse>, List<StudentCourse>, List<StudentCourse>, List<StudentCourse>> CompareStudentCourse(int studentID, List<StudentCourse> studentCourses)
        {
            if (studentID == -1)
                return Tuple.Create(studentCourses, new List<StudentCourse>(), new List<StudentCourse>(), new List<StudentCourse>());
            var savedCoursesLst = GetAllCourses(studentID);
            ToBeInsertedStudentCoursesComparer insertedCoursesComparer = new();
            ToBeUpdatedStudentCoursesComparer updatedCoursesComparer = new();
            List<StudentCourse> toBeSavedLst = studentCourses
                .Except(savedCoursesLst, insertedCoursesComparer)
                .ToList();
            List<StudentCourse> toBeRemovedLst = savedCoursesLst
                                                .Except(studentCourses, insertedCoursesComparer)
                                                .ToList();
            List<StudentCourse> toBeUpdatedLst = studentCourses
                                                .Except(savedCoursesLst, updatedCoursesComparer)
                                                .Except(toBeSavedLst, insertedCoursesComparer)
                                                .ToList();
            List<StudentCourse> toBeUpdatedOldMarksLst = savedCoursesLst
                                                        .Except(studentCourses, updatedCoursesComparer)
                                                        .Except(toBeSavedLst, insertedCoursesComparer)
                                                        .Except(toBeRemovedLst, insertedCoursesComparer)
                                                        .ToList();
            return Tuple.Create(toBeSavedLst, toBeRemovedLst, toBeUpdatedLst, toBeUpdatedOldMarksLst);
        }
        public bool UpdateStudentCourses(int studentID, AcademicRecordModels model)
        {
            string query = "";
            for (int i = 0; i < model.ToBeRemoved.Count; i++)
            {
                var obj = model.ToBeRemoved.ElementAt(i);
                query +=
                    string
                    .Format("UPDATE StudentCourses SET IsIncluded = 0 WHERE CourseID = {0} AND StudentID = {1} AND AcademicYearID = {2}; "
                    , obj.CourseID, studentID, obj.AcademicYearID);
            }
            for (int i = 0; i < model.ToBeUpdated.Count; i++)
            {
                var obj = model.ToBeUpdated.ElementAt(i);
                query += string
                    .Format("UPDATE StudentCourses SET Mark = {0} WHERE CourseID = {1} AND StudentID = {2} AND AcademicYearID = {3}; ",
                    obj.NewMark, obj.CourseID, studentID, obj.AcademicYearID);
            }
            for (int i = 0; i < model.ToBeInserted.Count(); i++)
            {
                var course = model.ToBeInserted.ElementAt(i);
                if (course.HasExecuse == true)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,HasExecuse,IsGpaIncluded) VALUES({0},{1},{2},{3},{4},{5});",
                        studentID, course.CourseID, course.AcademicYearID, 1, 1, 0);
                }
                else if (course.IsGpaIncluded == false && course.Mark == null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Grade) VALUES({0},{1},{2},{3},{4},'{5}');",
                        studentID, course.CourseID, course.AcademicYearID, 1, 0, course.Grade.Trim());
                }
                else if (course.IsGpaIncluded == false && course.Mark != null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5});",
                        studentID, course.CourseID, course.AcademicYearID, 1, 0, course.Mark);
                }
                else
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5});",
                            studentID, course.CourseID, course.AcademicYearID, 1, 1, course.Mark);
                }
            }
            if (string.IsNullOrEmpty(query))
                return true;
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@StudentID", studentID),
                new SqlParameter("@Query", query)
            };
            return QueryHelper.Execute(connectionString, "AddStudentCourses", parameters);
        }
        public CourseGradesSheetOutModel GetStudentsMarksList(int courseID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@CourseID", courseID);
            SqlConnection con = new(connectionString);
            var result = con.QueryMultiple("Report_CourseGradesSheet", parameters, commandType: CommandType.StoredProcedure);
            CourseGradesSheetOutModel model = new CourseGradesSheetOutModel();
            model.Course = result.ReadFirstOrDefault<CourseOutModel>();
            if (model.Course == null) return null;
            model.YearModel = result.ReadFirstOrDefault<AcademicYearOutModel>();
            model.Students = result.Read<StudentMarkOutModel>().ToList();
            return model;
        }
        public ExamCommitteeStudentsOutModel GetStudentsList(ExamCommitteeStudentsParamModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramID", model.ProgramID);
            parameters.Add("@CourseID", model.CourseID);
            parameters.Add("@Level", model.Level);
            SqlConnection con = new(connectionString);
            var result = con.QueryMultiple("Report_ExamCommitteeStudents", parameters, commandType: CommandType.StoredProcedure);
            ExamCommitteeStudentsOutModel outModel = new ExamCommitteeStudentsOutModel();
            outModel.Program = result.ReadFirstOrDefault<ProgramOutModel>();
            outModel.Course = result.ReadFirstOrDefault<CourseOutModel>();
            outModel.Students = result.Read<StudentOutModel>().ToList();
            return outModel;
        }

        public bool UpdateStudentsGradesFromSheet(List<GradesSheetUpdateModel> model)
        {
            string query = "";
            for (int i = 0; i < model.Count; i++)
                query += string.Concat("UPDATE StudentCourses SET Mark = ", model.ElementAt(i).Mark.HasValue ? model.ElementAt(i).Mark.Value : "NULL",
                    " WHERE StudentID = (SELECT ID FROM Student WHERE AcademicCode = ", model.ElementAt(i).AcademicCode, ")",
                    " AND AcademicYearID = ", model.ElementAt(i).AcademicYearID, " AND CourseID = ", model.ElementAt(i).CourseID, "; ");

            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@Query", query)
            };
            return QueryHelper.Execute(connectionString, "QueryExecuter", parameters);
        }
        public bool UpdateStudentCourses(List<StudentCourse> studentCourses)
        {
            int studentID = studentCourses.ElementAt(0).StudentId;
            var savedCoursesLst = GetAllCourses(studentID);
            ToBeInsertedStudentCoursesComparer insertedCoursesComparer = new();
            IEnumerable<StudentCourse> toBeSavedLst = studentCourses.Except(savedCoursesLst, insertedCoursesComparer);
            if (!toBeSavedLst.Any())
                return true;
            string query = "";
            for (int i = 0; i < toBeSavedLst.Count(); i++)
            {
                var course = toBeSavedLst.ElementAt(i);
                if (course.HasExecuse == true)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,HasExecuse,IsGpaIncluded) VALUES({0},{1},{2},{3},{4},{5});",
                        course.StudentId, course.CourseId, course.AcademicYearId, 1, 1, 0);
                }
                else if (course.IsGpaincluded == false && course.Mark == null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Grade) VALUES({0},{1},{2},{3},{4},'{5}');",
                        course.StudentId, course.CourseId, course.AcademicYearId, 1, 0, course.Grade.Trim());
                }
                else if (course.IsGpaincluded == false && course.Mark != null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5});",
                        course.StudentId, course.CourseId, course.AcademicYearId, 1, 0, course.Mark);
                }
                else
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5});",
                            course.StudentId, course.CourseId, course.AcademicYearId, 1, 1, course.Mark);
                }
            }
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@StudentID", studentID),
                new SqlParameter("@Query", query)
            };
            return QueryHelper.Execute(connectionString, "AddStudentCourses", parameters);
        }
    }
}