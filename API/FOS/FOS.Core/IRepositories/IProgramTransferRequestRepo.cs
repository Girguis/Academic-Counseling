using FOS.Core.Models.DTOs;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;

namespace FOS.Core.IRepositories
{
    public interface IProgramTransferRequestRepo
    {
        ProgramTransferRequestOutModel GetMyRequest(int studentID);
        (int totalCount, List<ProgramTransferRequestOutModel> Requests)
            GetRequests(SearchCriteria criteria, string? DoctorProgramID = null);
        bool DeleteRequest(int studentID);
        bool HandleRequest(int studentID, bool isApproved);
    }
}
