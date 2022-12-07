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

        public bool AddDesires(List<StudentDesire> desires)
        {
            var studnetId = desires.Select(x => x.StudentId).FirstOrDefault();

            var studentIdParam = new SqlParameter("@StudentID", studnetId);
            var dt = new DataTable();
            dt.Columns.Add("ProgramID");
            dt.Columns.Add("DesireNumber");
            for (var i = 0; i < desires.Count; i++)
            {
                dt.Rows.Add(desires[i].ProgramId, desires[i].DesireNumber);
            }
            var desiresParam = new SqlParameter("@Desires", dt);
            desiresParam.SqlDbType = SqlDbType.Structured;
            desiresParam.TypeName = "[dbo].[StudentDesiresType]";

            return context.Database.ExecuteSqlRaw("EXEC [dbo].[AddStudentDesires] @Desires, @StudentID", desiresParam, studentIdParam) > 0;
        }
        //public bool AddDesires(List<StudentDesire> desires)
        //{
        //    int studnetID = (int)desires.Select(x => x.StudentId).FirstOrDefault();
        //    if (context.StudentDesires.Where(x => x.StudentId == studnetID).Count() < 1)
        //    {
        //        //context.StudentDesires.AddRange(desires);
        //        for (int i = 0; i < desires.Count; i++)
        //            context.Add(desires.ElementAt(i));
        //        return context.SaveChanges() > 0;
        //    }
        //    else
        //        return UpdateDesires(desires);
        //}

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

        public List<StudentDesire> GetDesires(string guid)
        {
            IQueryable<StudentDesire> desires = context.StudentDesires.Where(x => x.Student.Guid == guid).Include(x => x.Program);
            if (desires.Count() < 1)
                return null;
            return desires.ToList();
        }

        public bool UpdateDesires(List<StudentDesire> desires)
        {
            //var oldDesires = context.StudentDesires.Where(x => x.StudentId == desires.Select(x => x.StudentId).FirstOrDefault());
            //context.RemoveRange(oldDesires);
            //context.AddRange(desires);
            context.Entry(desires).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
        public bool IsBifurcationAvailable()
        {
            Date date = context.Dates.Where(x => x.DateFor == 0).FirstOrDefault();
            DateTime currentDate = DateTime.UtcNow.AddHours(2);
            return currentDate >= date.StartDate && currentDate <= date.EndDate;
        }
    }
}
