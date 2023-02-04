using FOS.Core.IRepositories.Doctor;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Supervisor.Repositories
{
    public class StudentProgramRepo : IStudentProgramRepo
    {
        private readonly FOSContext context;

        public StudentProgramRepo(FOSContext context)
        {
            this.context = context;
        }
        /// <summary>
        /// Function to get number of students in each program
        /// </summary>
        /// <returns></returns>
        public object ProgramsStatistics()
        {
            var result = context.StudentPrograms.Include(x => x.Program)
                .ToList()
                .OrderByDescending(x => x.AcademicYear)
                .GroupBy(x => x.StudentId)
                .Select(x => x.FirstOrDefault());

            return result.GroupBy(x => x.Program).Select(x => new
            {
                Key = x.Key.Name,
                Count = x.Count()
            });
        }
    }
}
