using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ISuperAdminRepo
    {
        public SuperAdmin Login(string email, string hashedPassword);
        SuperAdmin Get(string GUID);
        bool Update(SuperAdmin superAdmin);
    }
}
