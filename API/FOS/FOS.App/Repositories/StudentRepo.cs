using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models.DTOs;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using FOS.Core.StudentDTOs;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using System.Data;

namespace FOS.App.Repositories
{
    public class StudentRepo : IStudentRepo
    {
        private readonly IDbContext config;
        public StudentRepo(IDbContext config)
        {
            this.config = config;
        }
        /// <summary>
        /// Method to get the academic details for a certian student
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public StudentAcademicReportDTO GetAcademicDetails(Student student)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", student.Id);
            parameters.Add("@ForDoctorView", 1);
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("Report_StudentAcademicReport", parameters, commandType: CommandType.StoredProcedure);
            var courses = result.Read<StudentCoursesDTO>().ToList();
            var academicYears = result.Read<AcademicYearDTO>().ToList();
            for (int i = 0; i < academicYears.Count; i++)
            {
                var currentYearCourses = courses.Where(x => x.AcademicYearID == academicYears.ElementAt(i).ID).ToList();
                academicYears.ElementAt(i).Courses = currentYearCourses;
                academicYears.ElementAt(i).SemesterHours = currentYearCourses.Sum(x => x.CreditHours);
                academicYears.ElementAt(i).PassedSemesterHours = currentYearCourses.Where(x => x.Grade.ToLower() != "f" && x.Grade != null).Sum(x => x.CreditHours);
                academicYears.ElementAt(i).CHours = (i == 0 ? academicYears.ElementAt(i).SemesterHours : academicYears.ElementAt(i - 1).CHours + academicYears.ElementAt(i).SemesterHours);
            }
            return new StudentAcademicReportDTO()
            {
                Name = student.Name,
                AcademicYearsDetails = academicYears,
                AvailableCredits = student.AvailableCredits,
                Cgpa = student.Cgpa,
                Level = student.Level,
                PassedHours = student.PassedHours,
                PhoneNumber = student.PhoneNumber,
                ProgramName = student.CurrentProgram.Name,
                SeatNumber = student.SeatNumber,
                SSN = student.Ssn,
                SupervisorName = student.Supervisor.Name,
                WarningsNumber = student.WarningsNumber,
            };
        }
        /// <summary>
        /// Method used to retrive student record from Student table by GUID
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public Student Get(string GUID, bool includeProgram = false, bool includeSupervisor = false)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@GUID", GUID);
            parameters.Add("@IncludeProgram", includeProgram);
            parameters.Add("@IncludeSupervisor", includeSupervisor);
            string splitOn = string.Empty;
            using var con = config.CreateInstance();
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
        public (int totalCount, List<StudentsDTO> students) GetAll(SearchCriteria criteria, string? DoctorProgramID = null)
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
            parameters.Add("@GetCoursesRequestsOnly", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "getcoursesrequestsonly")?.Value?.ToString());
            parameters.Add("@IsApprovedCourseRequest", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isapprovedcourserequest")?.Value?.ToString());
            parameters.GetPageParameters(criteria, "s.id");
            using var con = config.CreateInstance();
            var students = con.Query<StudentsDTO>
                ("GetStudents",
                param: parameters,
                commandType: CommandType.StoredProcedure
                )?.ToList();
            int totalCount = QueryExecuterHelper.GetTotalCountParamValue(parameters, students);
            return (totalCount, students);
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
            using var con = config.CreateInstance();
            return con.Query<Student>("Login_Student",
                param: parameters,
                commandType: CommandType.StoredProcedure)?.FirstOrDefault();
        }
        public Student GetBySSN(string ssn)
        {
            using var con = config.CreateInstance();
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@SSN", ssn);
            return con.Query<Student>("GetStudent", parameters, commandType: CommandType.StoredProcedure)?.FirstOrDefault();
        }
        public Student Add(Student student)
        {
            var std = GetBySSN(student.Ssn);
            if (std != null)
                return std;
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@GUID", student.Guid);
            parameters.Add("@Name", student.Name);
            parameters.Add("@SSN", student.Ssn);
            parameters.Add("@PhoneNumber", student.PhoneNumber);
            parameters.Add("@BirthDate", student.BirthDate);
            parameters.Add("@Address", student.Address);
            parameters.Add("@Gender", student.Gender);
            parameters.Add("@Nationality", student.Nationality);
            parameters.Add("@Email", student.Email);
            parameters.Add("@Password", student.Password);
            parameters.Add("@AcademicCode", student.AcademicCode);
            parameters.Add("@SeatNumber", student.SeatNumber);
            parameters.Add("@SupervisorID", student.SupervisorId);
            parameters.Add("@CreatedOn", student.CreatedOn);
            parameters.Add("@CurrentProgramID", student.CurrentProgramId);
            parameters.Add("@EnrollYearID", student.EnrollYearId);
            parameters.Add("@SemestersNumber", student.SemestersNumberInProgram);
            return QueryExecuterHelper.Execute<Student>(config.CreateInstance(),
                "AddStudent", parameters).FirstOrDefault();
        }

        public bool Update(Student student)
        {
            if (student == null) return false;
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "UpdateStudent",
                new List<SqlParameter>()
                {
                    new SqlParameter("@ID",student.Id),
                    new SqlParameter("@Name",student.Name),
                    new SqlParameter("@SSN",student.Ssn),
                    new SqlParameter("@PhoneNumber",student.PhoneNumber),
                    new SqlParameter("@BirthDate",student.BirthDate),
                    new SqlParameter("@Address",student.Address),
                    new SqlParameter("@Gender",student.Gender),
                    new SqlParameter("@Nationality",student.Nationality),
                    new SqlParameter("@Email",student.Email),
                    new SqlParameter("@Password", student.Password),
                    new SqlParameter("@SeatNumber",student.SeatNumber),
                    new SqlParameter("@SupervisorID", student.SupervisorId),
                    new SqlParameter("@IsCrossStudent", student.IsCrossStudent),
                    new SqlParameter("@CurrentProgramID",student.CurrentProgramId)
                });
        }
        public bool Deactivate(string guid)
        {
            var student = Get(guid);
            if (student == null) return false;
            return QueryExecuterHelper
                .Execute(config.CreateInstance(),
                "UPDATE Student SET IsActive = 0 WHERE ID =" + student.Id);
        }
        public bool Activate(string guid)
        {
            var student = Get(guid);
            if (student == null) return false;
            return QueryExecuterHelper
                .Execute(config.CreateInstance(),
                "UPDATE Student SET IsActive = 1 WHERE ID =" + student.Id);
        }

        public StudentCoursesSummaryOutModel GetStudentCoursesSummary(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("Report_StudentCoursesSummary", parameters, commandType: CommandType.StoredProcedure);
            var studentData = result.ReadFirstOrDefault<StudentDataReport>();
            if (studentData == null) return null;
            var coursesData = result.Read<CoursesDataReport>();
            return new StudentCoursesSummaryOutModel { Student = studentData, Courses = coursesData };
        }

        public List<StruggledStudentsOutModel> GetStruggledStudents(StruggledStudentsParamModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramID", model.ProgramID);
            parameters.Add("@IsActive", model.IsActive);
            parameters.Add("@WarningsNumber", model.WarningsNumber);
            using var con = config.CreateInstance();
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
            using var con = config.CreateInstance();
            var result = QueryExecuterHelper.Execute<AcademicYearsDTO>(con,
                "GetStudentAcademicYearsSummary",
                parameters);
            result?.Reverse();
            return result;
        }

        public float GetLastRegularSemesterGPA(int studentID)
        {
            var fnRes = QueryExecuterHelper.ExecuteFunction
                (config.CreateInstance(),
                "GetLastRegularSemesterGpa",
                studentID.ToString());
            if (fnRes == null)
                return 0.0f;
            bool paresd = float.TryParse(fnRes.ToString(), out float result);
            return paresd ? result : 0.0f;
        }

        public AcademicReportOutModel GetAcademicDetailsForReport(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            using var con = config.CreateInstance();
            AcademicReportOutModel reportOutModel = new AcademicReportOutModel();
            var result = con.QueryMultiple("Report_StudentAcademicReport", parameters, commandType: CommandType.StoredProcedure);
            reportOutModel.Student = result.ReadFirst<StudentAcademicReportDTO>();
            reportOutModel.Courses =  result.Read<StudentCoursesGradesOutModel>().ToList();
            reportOutModel.AcademicYears = result.Read<AcademicYearsDTO>().ToList();
            return reportOutModel;
        }

        public StudentCoursesSummaryTreeOutModel GetStudentCoursesSummaryTree(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("Report_StudentCoursesSummaryAsTree", parameters, commandType: CommandType.StoredProcedure);
            var programCourses = result.Read<ProgramCoursesOutModel>();
            var coursesData = result.Read<StudentCourseDetailsOutModel>();
            return new StudentCoursesSummaryTreeOutModel()
            {
                ProgramCourses = programCourses,
                StudentCourses = coursesData
            };
        }

        public bool ChangePassword(int id, string password)
        {
            var query = "UPDATE Student SET Password = '"
                + Helper.HashPassowrd(password)
                + "' WHERE ID = " + id;
            return QueryExecuterHelper.Execute(config.CreateInstance(), query);
        }

        public bool CanOpenCourseForGraduation(int studentID, byte passedHours, int programID, int hoursToSkip)
        {
            return (bool)QueryExecuterHelper.ExecuteFunction(config.CreateInstance(),
                "CanOpenCourseForGraduation",
                string.Concat(studentID, ",", passedHours, ",", programID, ",", hoursToSkip)
                );
        }

        public bool Add(DataTable dataTable)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddNewStudents",
                new List<SqlParameter>() {
                QueryExecuterHelper.DataTableToSqlParameter(dataTable, "Students", "StudentsAddType")
                }
            );
        }
        public List<GetReportByCgpaOutModel> ReportByCgpa(GetReportByCgpaParamModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@FromCgpa", model.FromCgpa);
            parameters.Add("@ToCgpa", model.ToCgpa);
            parameters.Add("@Level", model.Level);
            parameters.Add("@ProgramID", model.ProgramID);
            parameters.Add("@IsGraduated", model.IsGraduated);
            parameters.Add("@StartGraduationYearID", model.StartGraduationYearID);
            parameters.Add("@EndGraduationYearID", model.EndGraduationYearID);
            return QueryExecuterHelper.Execute<GetReportByCgpaOutModel>
                (config.CreateInstance(),
                "Report_GetStudentsByCGPA",
                parameters);
        }

        public int? GetRank(int studentID, int? programID)
        {
            var fnRes = QueryExecuterHelper.ExecuteFunction
                (config.CreateInstance(),
                "RankStudent",
                string.Concat(studentID.ToString(), ",", programID.ToString()));
            if (fnRes == null)
                return null;
            bool paresd = int.TryParse(fnRes.ToString(), out int result);
            return paresd ? result : null;
        }

        public IEnumerable<AcademicReportOutModel> AcademicReportsPerProgram(string programGuid)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramGuid", programGuid);
            var queryResult = config.CreateInstance().QueryMultiple("Report_MultipleAcademicReports",
                param: parameters, commandType: CommandType.StoredProcedure);
            var count = queryResult.ReadFirst<int>();
            var returnResult = new List<AcademicReportOutModel>();
            for (int i = 0; i < count; i++)
            {
                returnResult.Add(new AcademicReportOutModel()
                {
                    Student = queryResult.ReadFirst<StudentAcademicReportDTO>(),
                    Courses = queryResult.Read<StudentCoursesGradesOutModel>(),
                    AcademicYears = queryResult.Read<AcademicYearsDTO>(),
                });
            }
            return returnResult;
        }
    }
}
