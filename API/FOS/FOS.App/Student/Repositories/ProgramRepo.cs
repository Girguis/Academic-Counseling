using FOS.Core.IRepositories.Student;
using FOS.DB.Models;

namespace FOS.App.Student.Repositories
{
    public class ProgramRepo : IProgramRepo
    {
        private readonly FOSContext context;

        public ProgramRepo(FOSContext context)
        {
            this.context = context;
        }
        public Program GetProgram(int id)
        {
            return context.Programs.Where(x => x.Id == id).FirstOrDefault();
        }
    }
}
