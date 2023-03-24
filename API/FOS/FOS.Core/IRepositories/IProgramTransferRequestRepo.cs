using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.Core.IRepositories
{
    public interface IProgramTransferRequestRepo
    {
        List<ProgramTransferRequestOutModel> GetRequests(ProgramTransferSearchParamModel model = null, int? studentID = null);
        bool DeleteRequest(int studentID);
        bool HandleRequest(int studentID, bool isApproved);
    }
}
