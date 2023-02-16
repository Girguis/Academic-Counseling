using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class SupervisorRepo : ISupervisorRepo
    {
        private readonly FOSContext context;
        public SupervisorRepo(FOSContext context)
        {
            this.context = context;
        }

        public Supervisor Add(Supervisor supervisor)
        {
            var c = context.Supervisors.Add(supervisor);
            var res = context.SaveChanges();
            if (res > 0)
                return c.Entity;
            return null;
        }

        public bool Delete(string supervisorGUID)
        {
            var supervisor = GetById(supervisorGUID);
            if (supervisor == null) return false;
            supervisor.IsActive = false;
            return Update(supervisor);
        }

        public List<Supervisor> GetAll(out int totalCount, SearchCriteria criteria = null)
        {
            var supervisors = context.Supervisors;
            return DataFilter<Supervisor>.FilterData((DbSet<Supervisor>)supervisors, criteria, out totalCount, "Program");
        }

        /// <summary>
        /// Method to get supervisor details
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public Supervisor GetById(string GUID)
        {
            return context.Supervisors
                .Include(x => x.Program)
                .FirstOrDefault(x => x.Guid == GUID & x.IsActive == true);
        }

        public bool IsEmailReserved(string email)
        {
            return context.Supervisors.Any(x => x.Email == email);
        }

        /// <summary>
        /// Method to check the credentials, if it's valid then it will return the supervisor 
        /// else it will return null
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public Supervisor Login(string email, string hashedPassword)
        {
            return context.Supervisors
                .FirstOrDefault(x => x.Email == email &
                                x.Password == hashedPassword &
                                x.IsActive == true);
        }
        public bool Update(Supervisor supervisor)
        {
            if (supervisor == null) return false;
            context.Entry(supervisor).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
    }
}
