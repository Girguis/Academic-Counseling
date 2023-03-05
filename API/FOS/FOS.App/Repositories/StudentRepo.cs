using Dapper;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.SearchModels;
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
        public StudentRepo(FOSContext context,IConfiguration configuration)
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
        public List<Student> GetAll(out int totalCount, SearchCriteria criteria = null,bool includeProgram = true)
        {
            DbSet<Student> students = context.Students;
            return DataFilter<Student>.FilterData(students, criteria, out totalCount, (includeProgram == true?"CurrentProgram":""));
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
        /// Get number of males and females
        /// </summary>
        /// <returns></returns>
        public object GenderStatistics()
        {
            return context.Students.GroupBy(x => x.Gender).Select(x => new StatisticsModel
            {
                Key = x.Key,
                Value = x.Count()
            })?.ToList();
        }
        /// <summary>
        /// Method used to retrive student record from Student table by GUID
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public Student Get(string GUID)
        {
            return context.Students
                .Include("Doctor")
                .Include("CurrentProgram")
                .FirstOrDefault(x => x.Guid == GUID);
        }
        public Tuple<int,List<Student>> GetAll(SearchCriteria criteria, int? DoctorProgramID = null) 
        {
            DynamicParameters parameters = new();
            parameters.Add("@ProgramID", DoctorProgramID);
            parameters.Add("@AcademicCode", criteria.Filters.FirstOrDefault(x=>x.Key.ToLower() == "academiccode")?.Value?.ToString());
            parameters.Add("@SeatNumber", criteria.Filters.FirstOrDefault(x=>x.Key.ToLower() == "seatnumber")?.Value?.ToString());
            parameters.Add("@WarningsNumber", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "warningsnumber")?.Value?.ToString());
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
            parameters.Add("@PageNumber", criteria.PageNumber == 0 ? 1 : criteria.PageNumber);
            parameters.Add("@PageSize", criteria.PageSize == 0 ? 20 : criteria.PageSize);
            parameters.Add("@OrderBy", (string.IsNullOrEmpty(criteria.OrderByColumn) || criteria.OrderByColumn.ToLower() == "string") ? "s.id" : criteria.OrderByColumn);
            parameters.Add("@OrderDirection", criteria.Ascending ? "ASC" : "DESC");
            parameters.Add("@TotalCount",dbType:DbType.Int32,direction:ParameterDirection.Output);
            using SqlConnection con = new SqlConnection(connectionString);
            var stds = con.Query<Student, string,string, Student>
                ("GetStudents",
                (student, program, Doctor) =>
                {
                    student.CurrentProgram = new Program();
                    student.CurrentProgram.ArabicName = program;
                    student.Doctor = new Doctor();
                    student.Doctor.Name = Doctor; 
                    return student;
                },
                param: parameters,
                splitOn: "ProgramName,SupervisorName",
                commandType: CommandType.StoredProcedure
                )?.ToList();
            int totalCount;
            try{totalCount = parameters.Get<int>("TotalCount");}
            catch { totalCount = stds.Count; }
            return Tuple.Create(totalCount, stds);
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
            return context.Students.FirstOrDefault(x => x.Ssn == ssn);
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
    }
}
