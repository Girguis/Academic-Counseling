using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ISupervisorRepo
    {
        public Supervisor Login(string email, string hashedPassword);
        public Supervisor GetById(string GUID);
        public List<Supervisor> GetAll(out int totalCount, SearchCriteria criteria = null);
        public Supervisor Add(Supervisor supervisor);
        public bool Update(Supervisor supervisor);
        public bool Delete(string supervisorGUID);
        public bool IsEmailReserved(string email);
    }
}
