using FOS.Core.IRepositories.Supervisor;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Supervisor.Repositories
{
    public class SupervisorRepo : ISupervisorRepo
    {
        private readonly FOSContext context;
        public SupervisorRepo(FOSContext context)
        {
            this.context = context;
        }
        public DB.Models.Supervisor Get(string GUID)
        {
            return context.Supervisors
                .Include("Program")
                .FirstOrDefault(x => x.Guid == GUID & x.IsActive == true);
        }
        public DB.Models.Supervisor Login(string email, string hashedPassword)
        {
            return context.Supervisors
                .FirstOrDefault(x => x.Email == email &
                                x.Password == hashedPassword &
                                x.IsActive == true);
        }
        public bool Update(DB.Models.Supervisor supervisor)
        {
            context.Entry(supervisor).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
    }
}
