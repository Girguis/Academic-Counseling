using FOS.Core.IRepositories.Doctor;
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
        /// <summary>
        /// Method to get supervisor details
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public DB.Models.Supervisor Get(string GUID)
        {
            return context.Supervisors
                .Include("Program")
                .FirstOrDefault(x => x.Guid == GUID & x.IsActive == true);
        }
        /// <summary>
        /// Method to check the credentials, if it's valid then it will return the supervisor 
        /// else it will return null
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public DB.Models.Supervisor Login(string email, string hashedPassword)
        {
            return context.Supervisors
                .FirstOrDefault(x => x.Email == email &
                                x.Password == hashedPassword &
                                x.IsActive == true);
        }
    }
}
