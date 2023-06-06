using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models.DTOs;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using System.Data;

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

        public ProgramTransferRequestOutModel 
            GetMyRequest(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            return QueryExecuterHelper.Execute<ProgramTransferRequestOutModel>
                (config.CreateInstance(),
                "GetMyProgramTransferRequest"
                , parameters)?.FirstOrDefault();
        }

        public (int totalCount, List<ProgramTransferRequestOutModel> Requests) 
            GetRequests(SearchCriteria criteria, string DoctorProgramID = null)
        {
            DynamicParameters parameters = new();
            parameters.Add("@DoctorProgramID", DoctorProgramID);
            parameters.Add("@Name", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "name")?.Value?.ToString());
            parameters.Add("@Level", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "level")?.Value?.ToString());
            parameters.Add("@FromProgramID", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "fromprogramid")?.Value?.ToString());
            parameters.Add("@ToProgramID", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "toprogramid")?.Value?.ToString());
            parameters.Add("@IsApproved", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isapproved")?.Value?.ToString());
            parameters.GetPageParameters(criteria, "s.id");
            using var con = config.CreateInstance();
            var requests = con.Query<ProgramTransferRequestOutModel>
                ("GetProgramTransferRequests",
                param: parameters,
                commandType: CommandType.StoredProcedure
                )?.ToList();
            int totalCount = QueryExecuterHelper.GetTotalCountParamValue(parameters, requests);
            return (totalCount, requests);
        }

        public bool HandleRequest(int studentID, bool isApproved)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "UPDATE StudentProgramTransferRequest SET IsApproved = " + (isApproved ? 1 : 0)
                + " WHERE StudentID = " + studentID + ";");
        }
    }
}
