using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using System.Data;

namespace FOS.App.Repositories
{
    public class CourseRepo : ICourseRepo
    {
        private readonly IDbContext config;
        public CourseRepo(IDbContext config)
        {
            this.config = config;
        }
        public bool Add(AddCourseParamModel course)
        {
            var dt = new DataTable();
            dt.Columns.Add("CourseCode");
            dt.Columns.Add("CourseName");
            dt.Columns.Add("CreditHours");
            dt.Columns.Add("LectureHours");
            dt.Columns.Add("LabHours");
            dt.Columns.Add("SectionHours");
            dt.Columns.Add("IsActive");
            dt.Columns.Add("Level");
            dt.Columns.Add("Semester");
            dt.Rows.Add(course.CourseCode, course.CourseName,
                course.CreditHours, course.LectureHours,
                course.LabHours, course.SectionHours,
                course.IsActive, course.Level,
                course.Semester);
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddCourse",
                new List<SqlParameter>()
                {
                    QueryExecuterHelper.DataTableToSqlParameter(dt,"Courses","CourseType")
                });
        }
        public bool Delete(int id)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "DELETE FROM Course WHERE ID = " + id);
        }
        public List<Course> GetAll(out int totalCount, string doctorID, SearchCriteria criteria = null, int? doctorProgramID = null)
        {
            DynamicParameters parameters = new();
            parameters.Add("@ProgramID", doctorProgramID);
            parameters.Add("@CourseProgramID", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "courseprogramID")?.Value?.ToString());
            parameters.Add("@CourseCode", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "coursecode")?.Value?.ToString());
            parameters.Add("@CourseName", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "coursename")?.Value?.ToString());
            parameters.Add("@CreditHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "credithours")?.Value?.ToString());
            parameters.Add("@LectureHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "lecturehours")?.Value?.ToString());
            parameters.Add("@LabHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "labhours")?.Value?.ToString());
            if (!string.IsNullOrEmpty(doctorID))
                parameters.Add("@DoctorID", doctorID);
            parameters.Add("@SectionHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "sectionhours")?.Value?.ToString());
            parameters.Add("@IsActive", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isactive")?.Value?.ToString());
            parameters.Add("@Level", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "level")?.Value?.ToString());
            parameters.Add("@Semester", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "semester")?.Value?.ToString());
            parameters.Add("@PageNumber", criteria.PageNumber <= 0 ? 1 : criteria.PageNumber);
            parameters.Add("@PageSize", criteria.PageSize <= 0 ? 20 : criteria.PageSize);
            parameters.Add("@OrderBy", (string.IsNullOrEmpty(criteria.OrderByColumn) || criteria.OrderByColumn.ToLower() == "string") ? "c.id" : criteria.OrderByColumn);
            parameters.Add("@OrderDirection", criteria.Ascending ? "ASC" : "DESC");
            parameters.Add("@TotalCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            using var con = config.CreateInstance();
            var courses = con.Query<Course>("GetCourses", parameters, commandType: CommandType.StoredProcedure)?.ToList();
            try { totalCount = parameters.Get<int>("TotalCount"); }
            catch { totalCount = courses.Count; }
            return courses;
        }
        public List<Course> GetAll()
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Query", "SELECT ID,CourseCode,CourseName,Level,Semester,CreditHours FROM Course");
            return QueryExecuterHelper.Execute<Course>(config.CreateInstance(),
                "QueryExecuter", parameters);
        }
        public Course GetById(int id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Query", "SELECT * FROM Course WHERE ID = " + id);
            return QueryExecuterHelper.Execute<Course>(config.CreateInstance(),
                "QueryExecuter", parameters).FirstOrDefault();
        }
        public (Course course, IEnumerable<string> doctors, IEnumerable<string> programs) GetCourseDetails(int id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@CourseID", id);
            using var con = config.CreateInstance();
            var res = con.QueryMultiple("GetCourseDetails", parameters, commandType: System.Data.CommandType.StoredProcedure);
            var firstRes = res.ReadFirstOrDefault<Course>();
            var secondRes = res.Read<string>();
            var thirdResult = res.Read<string>();
            return (firstRes, secondRes, thirdResult);
        }
        public bool Update(int id, AddCourseParamModel course)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(), "UpdateCourse",
                new List<SqlParameter>()
                {
                    new SqlParameter("@ID",id),
                    new SqlParameter("@CourseCode",course.CourseCode),
                    new SqlParameter("@CourseName",course.CourseName),
                    new SqlParameter("@CreditHours",course.CreditHours),
                    new SqlParameter("@LectureHours",course.LectureHours),
                    new SqlParameter("@LabHours", course.LabHours),
                    new SqlParameter("@SectionHours",course.SectionHours),
                    new SqlParameter("@IsActive", course.IsActive),
                    new SqlParameter("@Level", course.Level),
                    new SqlParameter("@Semester", course.Semester)
                });
        }
        public bool Activate(List<int> courseIDs)
        {
            string courseLst = string.Concat("(", string.Join(",", courseIDs), ")");
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IsActive", true),
                new SqlParameter("@CourseLst", courseLst)
            };
            return QueryExecuterHelper.Execute(config.CreateInstance(), "CoursesActivation", parameters);
        }
        public bool Deactivate(List<int> courseIDs)
        {
            string courseLst = string.Concat("(", string.Join(",", courseIDs), ")");
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IsActive",false),
                new SqlParameter("@CourseLst", courseLst)
            };
            return QueryExecuterHelper.Execute(config.CreateInstance(), "CoursesActivation", parameters);
        }

        public bool AssignDoctorsToCourse(DoctorsToCourseParamModel model)
        {
            var dt = new DataTable();
            dt.Columns.Add("DoctorGuid");
            for (var i = 0; i < model.DoctorsGuid.Count; i++)
                dt.Rows.Add(model.DoctorsGuid[i]);
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AssignDoctorsToCourse", new List<SqlParameter>()
            {
                QueryExecuterHelper.DataTableToSqlParameter(dt,"Doctors","DoctorsGuidType"),
                new SqlParameter("@CourseID", model.CourseId)
            });
        }

        public bool IsCourseExist(string courseCode)
        {
            return (bool)QueryExecuterHelper
                .ExecuteFunction(config.CreateInstance(), "IsCourseExist",
                 "'" + courseCode + "'");
        }

        public bool ConfirmExamsResult()
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(), "ConfirmMarks", new List<SqlParameter>());
        }
    }
}