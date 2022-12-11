using FOS.Core.IRepositories.Supervisor;
using FOS.DB.Models;

namespace FOS.App.Supervisor.Repositories
{
    public class AcademicYearRepo : IAcademicYearRepo
    {
        private readonly FOSContext context;

        public AcademicYearRepo(FOSContext context)
        {
            this.context = context;
        }
        public bool StartNewYear()
        {
            AcademicYear currentAcademicYear = GetCurrentYear();
            var newSemester = (byte)((currentAcademicYear.Semester % 3.0) + 1);
            _ = int.TryParse(currentAcademicYear?.ToString()?.Split("/")[0], out int year);
            string newYear = year + 1 + "/" + (year + 2);
            AcademicYear newAcademicYear = new AcademicYear()
            {
                Semester = newSemester,
                AcademicYear1 = newYear
            };
            context.AcademicYears.Add(newAcademicYear);
            return context.SaveChanges() > 0;
        }
        public AcademicYear GetCurrentYear()
        {
            return context.AcademicYears
                   .OrderByDescending(x => x.Id)
                   .FirstOrDefault();
        }
        public List<AcademicYear> GetAcademicYearsList()
        {
            return context.AcademicYears.ToList();
        }
    }
}
