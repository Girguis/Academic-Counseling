using Dapper;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models.DTOs;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using FOS.Core.StudentDTOs;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class StudentRepo : IStudentRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;
        public StudentRepo(FOSContext context, IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }
        /// <summary>
        /// Method to get the academic details for a certian student
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public List<StudentCourse> GetAcademicDetails(string GUID)
        {
            return context.StudentCourses
                .Where(x => x.Student.Guid == GUID)
                .Include(x => x.AcademicYear)
                .Include(x => x.Course)
                .ToList();
        }
        /// <summary>
        /// Method to get all students from the database
        /// </summary>
        /// <param name="totalCount"></param>
        /// <param name="criteria"></param>
        /// <returns></returns>
        public List<Student> GetAll(out int totalCount, SearchCriteria criteria = null, bool includeProgram = true)
        {
            DbSet<Student> students = context.Students;
            return DataFilter<Student>.FilterData(students, criteria, out totalCount, includeProgram == true ? "CurrentProgram" : "");
        }
        /// <summary>
        /// Method to get student program history
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public List<StudentProgram> GetPrograms(string GUID)
        {
            return context.StudentPrograms
                .Where(x => x.Student.Guid == GUID)
                .Include(x => x.Program)
                .ToList();
        }

        /// <summary>
        /// Method to get student who have 1 or more warning
        /// </summary>
        /// <param name="totalCount"></param>
        /// <param name="criteria"></param>
        /// <returns></returns>
        public List<Student> GetStudentsWithWarnings(out int totalCount, SearchCriteria criteria = null)
        {
            criteria.Filters ??= new List<SearchBaseModel>();
            criteria.Filters.Add(new SearchBaseModel()
            {
                Key = "WarningsNumber",
                Operator = ">",
                Value = 0
            });
            return GetAll(out totalCount, criteria)?.ToList();
        }
        /// <summary>
        /// Method used to retrive student record from Student table by GUID
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public Student Get(string GUID, bool includeProgram = false, bool includeSupervisor = false)
        {
            SqlConnection con = new SqlConnection(connectionString);
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@GUID", GUID);
            parameters.Add("@IncludeProgram", includeProgram);
            parameters.Add("@IncludeSupervisor", includeSupervisor);
            string splitOn = string.Empty;
            if (includeProgram && includeSupervisor)
            {
                splitOn = "ProgramName,SupervisorName";
                return con.Query<Student, string, string, Student>
                        ("GetStudent",
                        (student, programName, supervisorName) =>
                        {
                            Program p = new Program();
                            student.CurrentProgram = p;
                            student.CurrentProgram.Name = programName;
                            DB.Models.Doctor d = new DB.Models.Doctor();
                            student.Supervisor = d;
                            student.Supervisor.Name = supervisorName;
                            return student;
                        },
                        parameters,
                        splitOn: splitOn,
                        commandType: CommandType.StoredProcedure)?
                        .FirstOrDefault();
            }
            else if (includeProgram)
            {
                splitOn = "ProgramName";
                return con.Query<Student, string, Student>
                      ("GetStudent",
                      (student, programName) =>
                      {
                          Program p = new Program();
                          student.CurrentProgram = p;
                          student.CurrentProgram.Name = programName;
                          return student;
                      },
                      parameters,
                      splitOn: splitOn,
                      commandType: CommandType.StoredProcedure)?
                      .FirstOrDefault();
            }
            else if (includeSupervisor)
            {
                splitOn = "SupervisorName";
                return con.Query<Student, string, Student>
                      ("GetStudent",
                      (student, supervisorName) =>
                      {
                          DB.Models.Doctor d = new DB.Models.Doctor();
                          student.Supervisor = d;
                          student.Supervisor.Name = supervisorName;
                          return student;
                      },
                      parameters,
                      splitOn: splitOn,
                      commandType: CommandType.StoredProcedure)?
                      .FirstOrDefault();
            }
            else
            {
                return con.Query<Student>("GetStudent", parameters, commandType: CommandType.StoredProcedure)?.FirstOrDefault();
            }
        }
        public (int totalCount, List<StudentsDTO> students) GetAll(SearchCriteria criteria, int? DoctorProgramID = null)
        {
            DynamicParameters parameters = new();
            parameters.Add("@ProgramID", DoctorProgramID);
            parameters.Add("@AcademicCode", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "academiccode")?.Value?.ToString());
            parameters.Add("@SeatNumber", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "seatnumber")?.Value?.ToString());
            parameters.Add("@WarningsNumber", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "warningsnumber")?.Value?.ToString());
            var warningsOp = criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "warningsnumber")?.Operator?.ToString();
            parameters.Add("@WarningsOp", string.IsNullOrEmpty(warningsOp) ? "=" : warningsOp);
            parameters.Add("@SupervisorID", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "supervisorid")?.Value?.ToString());
            parameters.Add("@CGPA", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "cgpa")?.Value?.ToString());
            parameters.Add("@PassedHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "passedhours")?.Value?.ToString());
            parameters.Add("@Level", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "level")?.Value?.ToString());
            parameters.Add("@Gender", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "gender")?.Value?.ToString());
            parameters.Add("@IsGraduated", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isgraduated")?.Value?.ToString());
            parameters.Add("@IsActive", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isactive")?.Value?.ToString());
            parameters.Add("@CurrentProgramID", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "currentprogramid")?.Value?.ToString());
            parameters.Add("@Name", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "name")?.Value?.ToString());
            parameters.Add("@SSN", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "ssn")?.Value?.ToString());
            parameters.Add("@PhoneNumber", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "phonenumber")?.Value?.ToString());
            parameters.Add("@Address", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "address")?.Value?.ToString());
            parameters.Add("@IncludeRegistrationDetails", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "includeregistrationdetails")?.Value?.ToString());
            parameters.Add("@PageNumber", criteria.PageNumber <= 0 ? 1 : criteria.PageNumber);
            parameters.Add("@PageSize", criteria.PageSize <= 0 ? 20 : criteria.PageSize);
            parameters.Add("@OrderBy", (string.IsNullOrEmpty(criteria.OrderByColumn) || criteria.OrderByColumn.ToLower() == "string") ? "s.id" : criteria.OrderByColumn);
            parameters.Add("@OrderDirection", criteria.Ascending ? "ASC" : "DESC");
            parameters.Add("@TotalCount", dbType: DbType.Int32, direction: ParameterDirection.Output);
            using SqlConnection con = new SqlConnection(connectionString);
            var students = con.Query<StudentsDTO>
                ("GetStudents",
                param: parameters,
                commandType: CommandType.StoredProcedure
                )?.ToList();
            int totalCount;
            try { totalCount = parameters.Get<int>("TotalCount"); }
            catch { totalCount = students.Count; }
            return (totalCount, students);
        }
        /// <summary>
        /// Method used to get student current program
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public StudentProgram GetCurrentProgram(string GUID)
        {
            return context.StudentPrograms
                .Where(x => x.Student.Guid == GUID)
                .OrderBy(x => x.AcademicYear)
                .Include(x => x.Program)
                .LastOrDefault();
        }
        /// <summary>
        /// Method used to get student with provided E-mail and password
        /// returns null if E-mail or password are invalid
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public Student Login(string email, string hashedPassword)
        {
            DynamicParameters parameters = new();
            parameters.Add("@Email", email);
            parameters.Add("@Password", hashedPassword);
            using SqlConnection con = new SqlConnection(connectionString);
            return con.Query<Student>("Login_Student",
                param: parameters,
                commandType: CommandType.StoredProcedure)?.FirstOrDefault();
        }
        public Student GetBySSN(string ssn)
        {
            SqlConnection con = new SqlConnection(connectionString);
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@SSN", ssn);
            return con.Query<Student>("GetStudent", parameters, commandType: CommandType.StoredProcedure)?.FirstOrDefault();
        }
        public Student Add(Student student)
        {
            var std = GetBySSN(student.Ssn);
            if (std != null)
                return std;

            var res = context.Students.Add(student);
            if (context.SaveChanges() > 0)
                return res.Entity;
            return null;
        }

        public bool Update(Student student)
        {
            if (student == null) return false;
            context.Entry(student).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }

        public bool Deactivate(string guid)
        {
            var student = Get(guid);
            if (student == null) return false;
            student.IsActive = false;
            context.Entry(student).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
        public bool Activate(string guid)
        {
            var student = Get(guid);
            if (student == null) return false;
            student.IsActive = true;
            context.Entry(student).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }

        public StudentCoursesSummaryOutModel GetStudentCoursesSummary(int studentID)
        {
            SqlConnection con = new(connectionString);
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            var result = con.QueryMultiple("Report_StudentCoursesSummary", parameters, commandType: CommandType.StoredProcedure);
            var studentData = result.ReadFirstOrDefault<StudentDataReport>();
            if (studentData == null) return null;
            var coursesData = result.Read<CoursesDataReport>();
            return new StudentCoursesSummaryOutModel { Student = studentData, Courses = coursesData };
        }

        public List<StruggledStudentsOutModel> GetStruggledStudents(StruggledStudentsParamModel model)
        {
            SqlConnection con = new(connectionString);
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramID", model.ProgramID);
            parameters.Add("@IsActive", model.IsActive);
            parameters.Add("@WarningsNumber", model.WarningsNumber);
            return con.Query<StruggledStudentsOutModel>
                ("Report_GetStruggledStudents",
                parameters
                , commandType: CommandType.StoredProcedure)
                ?.ToList();
        }

        public List<AcademicYearsDTO> GetStudentAcademicYearsSummary(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            SqlConnection con = new SqlConnection(connectionString);
            var result = con.Query<AcademicYearsDTO>("GetStudentAcademicYearsSummary", parameters, commandType: CommandType.StoredProcedure)?.ToList();
            result?.Reverse();
            return result;
        }

        public float GetLastRegularSemesterGPA(int studentID)
        {
            var fnRes = QueryHelper.ExecuteFunction(connectionString,
                "GetLastRegularSemesterGpa",
                new List<object>()
            {
                studentID
            });
            if(fnRes == null)
                return 0.0f;
            bool paresd = float.TryParse(fnRes.ToString(), out float result);
            return paresd ? result : 0.0f;
        }

        public (List<AcademicYearsDTO> academicYears,
            List<StudentCoursesGradesOutModel> courses) 
            GetAcademicDetailsForReport(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            SqlConnection con = new(connectionString);
            var result = con.QueryMultiple("Report_StudentAcademicReport",parameters,commandType: CommandType.StoredProcedure);
            var courses = result.Read<StudentCoursesGradesOutModel>().ToList();
            var academicYears = result.Read<AcademicYearsDTO>().ToList();
            return (academicYears,courses);
        }

        public StudentCoursesSummaryTreeOutModel GetStudentCoursesSummaryTree(int studentID)
        {
            SqlConnection con = new(connectionString);
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            var result = con.QueryMultiple("Report_StudentCoursesSummaryAsTree", parameters, commandType: CommandType.StoredProcedure);
            var programCourses = result.Read<ProgramCoursesOutModel>();
            var coursesData = result.Read<StudentCourseDetailsOutModel>();
            return new StudentCoursesSummaryTreeOutModel()
            {
                ProgramCourses = programCourses,
                StudentCourses = coursesData
            };
        }
    }
}
