using FOS.Core.IRepositories;
using FOS.DB.Models;

namespace FOS.App.Repositories
{
    public class ProgramRepo : IProgramRepo
    {
        private readonly FOSContext context;

        public ProgramRepo(FOSContext context)
        {
            this.context = context;
        }
        /// <summary>
        /// Method to get details of a certain program by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public Program GetProgram(int id)
        {
            return context.Programs.Where(x => x.Id == id).FirstOrDefault();
        }
        public List<Program> GetPrograms()
        {
            return context.Programs.ToList();
        }
    }
}
