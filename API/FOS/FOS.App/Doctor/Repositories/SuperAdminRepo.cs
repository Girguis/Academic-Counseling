using FOS.Core.IRepositories.Doctor;
using FOS.DB.Models;

namespace FOS.App.Supervisor.Repositories
{
    public class SuperAdminRepo : ISuperAdminRepo
    {
        private readonly FOSContext context;
        public SuperAdminRepo(FOSContext context)
        {
            this.context = context;
        }
        /// <summary>
        /// Method to get supervisor details
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public SuperAdmin Get(string GUID)
        {
            return context.SuperAdmins
                .FirstOrDefault(x => x.Guid == GUID);
        }
        /// <summary>
        /// Method to check the credentials, if it's valid then it will return the supervisor 
        /// else it will return null
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public SuperAdmin Login(string email, string hashedPassword)
        {
            return context.SuperAdmins
                .FirstOrDefault(x => x.Email == email &
                                x.Password == hashedPassword);
        }
    }
}
