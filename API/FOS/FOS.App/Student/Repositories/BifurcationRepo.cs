using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace FOS.App.Student.Repositories
{
    public class BifurcationRepo : IBifurcationRepo
    {
        private readonly FOSContext context;
        private readonly IStudentRepo studentRepo;
        private readonly IAcademicYearRepo academicYearRepo;

        public BifurcationRepo(FOSContext context, IStudentRepo studentRepo, IAcademicYearRepo academicYearRepo)
        {
            this.context = context;
            this.studentRepo = studentRepo;
            this.academicYearRepo = academicYearRepo;
        }
        /// <summary>
        /// Method to execute a stored procedure that removes old StudentDesire and add new desires
        /// </summary>
        /// <param name="desires"></param>
        /// <returns></returns>
        public bool AddDesires(int studentID,List<byte> desires)
        {
            var studentIdParam = new SqlParameter("@StudentID", studentID);
            var dt = new DataTable();
            dt.Columns.Add("ProgramID");
            dt.Columns.Add("DesireNumber");
            for (var i = 0; i < desires.Count; i++)
            {
                dt.Rows.Add(desires[i], (i + 1));
            }
            var desiresParam = new SqlParameter("@Desires", dt);
            desiresParam.SqlDbType = SqlDbType.Structured;
            desiresParam.TypeName = "[dbo].[StudentDesiresType]";

            return context.Database.ExecuteSqlRaw("EXEC [dbo].[AddStudentDesires] @Desires, @StudentID", desiresParam, studentIdParam) > 0;
        }
        /// <summary>
        /// Method to get programs that student can choose from
        /// i.e i'm a first year CS student and we are in the second term
        /// this function will send me 2 programs CS pure and CS/Math
        /// </summary>
        /// <param name="guid"></param>
        /// <returns></returns>
        public List<Program> GetAvailableProgram(string guid)
        {
            DB.Models.Student student = studentRepo.Get(guid);
            Program studentProgram = studentRepo.GetCurrentProgram(guid);
            List<Program> subPrograms = new List<Program>();
            if (studentProgram == null)
            {
                subPrograms = context.ProgramRelations
                .Where(x => x.Program == null)
                .Include(x => x.SubProgramNavigation)
                .Select(x => x.SubProgramNavigation)
                .ToList();
            }
            else
            {
                subPrograms = context.ProgramRelations
                .Where(x => x.Program == studentProgram.Id)
                .Include(x => x.SubProgramNavigation)
                .Select(x => x.SubProgramNavigation)
                .ToList();
            }
            List<Program> result = subPrograms
                .Where(x => x.Semester == student.SemestersNumberInProgram & (x.Semester % 2) == (academicYearRepo.GetCurrentYear().Semester % 2))
                .ToList();
            return result;
        }
        /// <summary>
        /// Method to get student desires from database
        /// </summary>
        /// <param name="guid"></param>
        /// <returns></returns>
        public List<StudentDesire> GetDesires(string guid)
        {
            IQueryable<StudentDesire> desires = context.StudentDesires.Where(x => x.Student.Guid == guid).Include(x => x.Program);
            if (desires.Count() < 1)
                return null;
            return desires.ToList();
        }
    }
}
