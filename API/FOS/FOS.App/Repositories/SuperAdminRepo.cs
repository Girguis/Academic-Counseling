using Dapper;
using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class SuperAdminRepo : ISuperAdminRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public SuperAdminRepo(FOSContext context, IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }
        /// <summary>
        /// Method to get supervisor details
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public SuperAdmin Get(string GUID)
        {
            return context.SuperAdmins
                .FirstOrDefault(x => x.Guid == GUID);
        }
        /// <summary>
        /// Method to check the credentials, if it's valid then it will return the supervisor 
        /// else it will return null
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public SuperAdmin Login(string email, string hashedPassword)
        {
            DynamicParameters parameters = new();
            parameters.Add("@Email", email);
            parameters.Add("@Password", hashedPassword);
            using SqlConnection con = new SqlConnection(connectionString);
            return con.Query<SuperAdmin>("Login_SuperAdmin",
                param: parameters,
                commandType: CommandType.StoredProcedure)?.FirstOrDefault();
        }

        public bool Update(SuperAdmin superAdmin)
        {
            if (superAdmin == null)
                return false;
            context.Entry(superAdmin).State = Microsoft.EntityFrameworkCore.EntityState.Modified;
            return context.SaveChanges() > 0;
        }
    }
}
