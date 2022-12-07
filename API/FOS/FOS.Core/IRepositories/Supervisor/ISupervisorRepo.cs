namespace FOS.Core.IRepositories.Supervisor
{
    public interface ISupervisorRepo
    {
        public DB.Models.Supervisor Login(string email, string hashedPassword);
        DB.Models.Supervisor Get(string GUID);
        bool Update(DB.Models.Supervisor supervisor);

    }
}
