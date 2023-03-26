using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models.StoredProcedureOutputModels;
using Microsoft.Data.SqlClient;

namespace FOS.App.Repositories
{
    public class SuperAdminRepo : ISuperAdminRepo
    {
        private readonly IDbContext config;

        public SuperAdminRepo(IDbContext config)
        {
            this.config = config;
        }

        public bool ChangePassword(string guid, string password)
        {
            return QueryExecuterHelper.Execute
                (config.CreateInstance(),
                "UpdateSuperAdminPassword",
                new List<SqlParameter>()
                {
                    new SqlParameter("@Guid", guid),
                    new SqlParameter("@Password", Helper.HashPassowrd(password))
                });
        }

        /// <summary>
        /// Method to get supervisor details
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public SuperAdminOutModel Get(string GUID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Guid", GUID);
            return QueryExecuterHelper.Execute<SuperAdminOutModel>
                (config.CreateInstance(),
                "GetSuperAdmin",
                parameters).FirstOrDefault();
        }
        /// <summary>
        /// Method to check the credentials, if it's valid then it will return the supervisor 
        /// else it will return null
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public SuperAdminOutModel Login(string email, string hashedPassword)
        {
            DynamicParameters parameters = new();
            parameters.Add("@Email", email);
            parameters.Add("@Password", hashedPassword);
            return QueryExecuterHelper.Execute<SuperAdminOutModel>(config.CreateInstance(),
                "Login_SuperAdmin",
                parameters)?.FirstOrDefault();
        }
    }
}
