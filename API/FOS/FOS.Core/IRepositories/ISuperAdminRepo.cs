using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.Core.IRepositories
{
    public interface ISuperAdminRepo
    {
        public SuperAdminOutModel Login(string email, string hashedPassword);
        SuperAdminOutModel Get(string GUID);
        bool ChangePassword(string guid, string password);
    }
}
