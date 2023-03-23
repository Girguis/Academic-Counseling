using Dapper;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class CourseRepo : ICourseRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public CourseRepo(FOSContext context, IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
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
        public List<Course> GetAll(out int totalCount, SearchCriteria criteria = null, int? doctorProgramID = null)
        {
            DynamicParameters parameters = new();
            parameters.Add("@ProgramID", doctorProgramID);
            parameters.Add("@CourseProgramID", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "courseprogramID")?.Value?.ToString());
            parameters.Add("@CourseCode", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "coursecode")?.Value?.ToString());
            parameters.Add("@CourseName", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "coursename")?.Value?.ToString());
            parameters.Add("@CreditHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "credithours")?.Value?.ToString());
            parameters.Add("@LectureHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "lecturehours")?.Value?.ToString());
            parameters.Add("@LabHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "labhours")?.Value?.ToString());
            parameters.Add("@SectionHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "sectionhours")?.Value?.ToString());
            parameters.Add("@IsActive", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isactive")?.Value?.ToString());
            parameters.Add("@Level", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "level")?.Value?.ToString());
            parameters.Add("@Semester", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "semester")?.Value?.ToString());
            parameters.Add("@PageNumber", criteria.PageNumber <= 0 ? 1 : criteria.PageNumber);
            parameters.Add("@PageSize", criteria.PageSize <= 0 ? 20 : criteria.PageSize);
            parameters.Add("@OrderBy", (string.IsNullOrEmpty(criteria.OrderByColumn) || criteria.OrderByColumn.ToLower() == "string") ? "c.id" : criteria.OrderByColumn);
            parameters.Add("@OrderDirection", criteria.Ascending ? "ASC" : "DESC");
            parameters.Add("@TotalCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            using SqlConnection con = new SqlConnection(connectionString);
            var courses = con.Query<Course>("GetCourses", parameters, commandType: CommandType.StoredProcedure)?.ToList();
            try { totalCount = parameters.Get<int>("TotalCount"); }
            catch { totalCount = courses.Count; }
            return courses;
        }
        public List<Course> GetAll()
        {
            return context.Courses.AsNoTracking().AsParallel().ToList();
        }
        public Course GetById(int id)
        {
            return context.Courses.FirstOrDefault(x => x.Id == id);
        }
        public (Course course, IEnumerable<string> doctors, IEnumerable<string> programs) GetCourseDetails(int id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@CourseID", id);
            SqlConnection con = new SqlConnection(connectionString);
            var res = con.QueryMultiple("GetCourseDetails", parameters, commandType: System.Data.CommandType.StoredProcedure);
            var firstRes = res.ReadFirstOrDefault<Course>();
            var secondRes = res.Read<string>();
            var thirdResult = res.Read<string>();
            return (firstRes, secondRes, thirdResult);
        }
        public bool Update(Course course)
        {
            if (course == null) return false;
            context.Entry(course).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
        public bool Activate(List<int> courseIDs)
        {
            string courseLst = string.Concat("(", string.Join(",", courseIDs), ")");
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IsActive", true),
                new SqlParameter("@CourseLst", courseLst)
            };
            return QueryExecuterHelper.Execute(connectionString, "CoursesActivation", parameters);
        }
        public bool Deactivate(List<int> courseIDs)
        {
            string courseLst = string.Concat("(", string.Join(",", courseIDs), ")");
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IsActive",false),
                new SqlParameter("@CourseLst", courseLst)
            };
            return QueryExecuterHelper.Execute(connectionString, "CoursesActivation", parameters);
        }

        public bool AssignDoctorsToCourse(DoctorsToCourseParamModel model)
        {
            var dt = new DataTable();
            dt.Columns.Add("DoctorGuid");
            for (var i = 0; i < model.DoctorsGuid.Count; i++)
            {
                dt.Rows.Add(model.DoctorsGuid[i]);
            }
            return QueryExecuterHelper.Execute(connectionString, "AssignDoctorsToCourse", new List<SqlParameter>()
            {
                QueryExecuterHelper.DataTableToSqlParameter(dt,"Doctors","DoctorsGuidType"),
                new SqlParameter("@CourseID", model.CourseId)
            });
        }
    }
}