namespace FOS.Core.IRepositories
{
    public interface ISupervisorRepo
    {
        public DB.Models.Supervisor Login(string email, string hashedPassword);
        DB.Models.Supervisor Get(string GUID);
    }
}
