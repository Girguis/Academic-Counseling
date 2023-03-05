using Dapper;
using FOS.App.Comparers;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class StudentProgramRepo : IStudentProgramRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public StudentProgramRepo(FOSContext context,IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString= this.configuration["ConnectionStrings:FosDB"];
        }

        public bool AddStudentProgram(StudentProgram studentProgram)
        {
            if (GetStudentProgram(studentProgram) == null)
            {
                context.StudentPrograms.Add(studentProgram);
                return context.SaveChanges() > 0;
            }
            return true;
        }

        public bool AddStudentPrograms(List<StudentProgramModel> model)
        {
            var savedStudentProgramsLst = GetAllStudentPrograms(model.ElementAt(0).StudentId);
            var studentPrograms = model.Select(x => new StudentProgram()
            {
                StudentId = x.StudentId,
                AcademicYear = x.AcademicYear,
                ProgramId = x.ProgramId,
                AcademicYearNavigation = null,
                Program = null,
                Student = null
            });
            StudentProgramComparer programComparer = new StudentProgramComparer();
            IEnumerable<StudentProgram> toBeSavedLst = studentPrograms.Except(savedStudentProgramsLst, programComparer);
            if (!toBeSavedLst.Any())
                return true;
            var dt = new DataTable();
            dt.Columns.Add("ProgramID");
            dt.Columns.Add("StudentID");
            dt.Columns.Add("AcademicYearID");
            for (var i = 0; i < toBeSavedLst.Count(); i++)
                dt.Rows.Add(toBeSavedLst.ElementAt(i).ProgramId, toBeSavedLst.ElementAt(i).StudentId, toBeSavedLst.ElementAt(i).AcademicYear);

            var studentProgramParam = QueryHelper.DataTableToSqlParameter(dt, "StudentProgram", "StudentsProgramsType");
            return context.Database.ExecuteSqlRaw("EXEC [dbo].[AddStudentsToPrograms] @StudentProgram", studentProgramParam) > 0;
        }

        public IEnumerable<StudentProgram> GetAllStudentPrograms(int studentID)
        {
            return context.StudentPrograms.Where(x => x.StudentId == studentID).AsParallel();
        }

        public Program GetStudentCurrentProgram(int studentID)
        {
            return context.StudentPrograms
                .Where(x => x.StudentId == studentID)
                .Include(x => x.Program)
                .AsNoTracking()
                .AsParallel()
                .MaxBy(x => x.AcademicYear)
                .Program;
        }

        public StudentProgram GetStudentProgram(StudentProgram studentProgram)
        {
            return context.StudentPrograms
                .FirstOrDefault(x => x.StudentId == studentProgram.StudentId
                                && x.ProgramId == studentProgram.ProgramId
                                && x.AcademicYear == studentProgram.AcademicYear);
        }

        /// <summary>
        /// Function to get number of students in each program
        /// </summary>
        /// <returns></returns>
        public object ProgramsStatistics()
        {
            SqlConnection con = new SqlConnection(connectionString);
            return con.Query<StatisticsModel>("ProgramsStatistics", commandType: CommandType.StoredProcedure);
        }
    }
}
