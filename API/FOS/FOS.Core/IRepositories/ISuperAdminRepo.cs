namespace FOS.Core.IRepositories
{
    public interface ISuperAdminRepo
    {
        public DB.Models.SuperAdmin Login(string email, string hashedPassword);
        DB.Models.SuperAdmin Get(string GUID);
    }
}
