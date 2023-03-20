using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IDoctorRepo
    {
        public Doctor Login(string email, string hashedPassword);
        public Doctor GetById(string GUID, bool isActive = true);
        public List<Doctor> GetAll(out int totalCount, SearchCriteria criteria = null);
        public Doctor Add(Doctor supervisor);
        public bool Update(Doctor supervisor);
        public bool Deactivate(string supervisorGUID);
        public bool Activate(string supervisorGUID);
        public bool IsEmailReserved(string email);
        public List<Program> GetDoctorPrograms(string guid);
    }
}
