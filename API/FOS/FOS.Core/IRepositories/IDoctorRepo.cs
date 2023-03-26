using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;

namespace FOS.Core.IRepositories
{
    public interface IDoctorRepo
    {
        public DoctorOutModel Login(string email, string hashedPassword);
        public DoctorOutModel GetById(string GUID, bool isActive = true);
        public List<DoctorOutModel> GetAll(out int totalCount, SearchCriteria criteria = null);
        public bool Add(DoctorAddParamModel supervisor);
        public bool Update(string guid, DoctorUpdateParamModel supervisor);
        public bool ChangePassword(string guid, string password);
        public bool Deactivate(string supervisorGUID);
        public bool Activate(string supervisorGUID);
        public bool IsEmailReserved(string email);
    }
}
