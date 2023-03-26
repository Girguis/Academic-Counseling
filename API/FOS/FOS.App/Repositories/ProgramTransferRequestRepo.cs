using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.App.Repositories
{
    public class ProgramTransferRequestRepo : IProgramTransferRequestRepo
    {
        private readonly IDbContext config;

        public ProgramTransferRequestRepo(IDbContext config)
        {
            this.config = config;
        }
        public bool DeleteRequest(int studentID)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "DELETE FROM StudentProgramTransferRequest WHERE StudentID = " + studentID + ";");
        }

        public List<ProgramTransferRequestOutModel> GetRequests(ProgramTransferSearchParamModel model = null, int? studentID = null)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            if (model != null)
            {
                parameters.Add("@ToProgramID", model.ToProgramID);
                parameters.Add("@IsApproved", model.IsApproved);
            }
            return QueryExecuterHelper.Execute<ProgramTransferRequestOutModel>
                (config.CreateInstance(),
                "GetProgramTransferRequests"
                , parameters);
        }

        public bool HandleRequest(int studentID, bool isApproved)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "UPDATE StudentProgramTransferRequest SET IsApproved = " + (isApproved ? 1 : 0)
                + " WHERE StudentID = " + studentID + ";");
        }
    }
}
