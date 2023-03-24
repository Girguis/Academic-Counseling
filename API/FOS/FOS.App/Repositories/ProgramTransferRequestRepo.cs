using Dapper;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FOS.App.Repositories
{
    public class ProgramTransferRequestRepo : IProgramTransferRequestRepo
    {
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public ProgramTransferRequestRepo(IConfiguration configuration)
        {
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }
        public bool DeleteRequest(int studentID)
        {
            return QueryExecuterHelper.Execute(connectionString,
                "DELETE FROM StudentProgramTransferRequest WHERE StudentID = " + studentID + ";");
        }

        public List<ProgramTransferRequestOutModel> GetRequests(ProgramTransferSearchParamModel model = null,int? studentID = null)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            if (model != null)
            {
                parameters.Add("@ToProgramID", model.ToProgramID);
                parameters.Add("@IsApproved", model.IsApproved);
            }
            return QueryExecuterHelper.Execute<ProgramTransferRequestOutModel>(connectionString,
                "GetProgramTransferRequests"
                , parameters);
        }

        public bool HandleRequest(int studentID, bool isApproved)
        {
            return QueryExecuterHelper.Execute(connectionString,
                "UPDATE StudentProgramTransferRequest SET IsApproved = " + (isApproved ? 1 : 0)
                + " WHERE StudentID = " + studentID + ";");
        }
    }
}
