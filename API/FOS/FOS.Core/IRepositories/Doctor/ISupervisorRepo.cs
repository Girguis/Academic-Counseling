namespace FOS.Core.IRepositories.Doctor
{
    public interface ISupervisorRepo
    {
        public DB.Models.Supervisor Login(string email, string hashedPassword);
        DB.Models.Supervisor Get(string GUID);
    }
}
