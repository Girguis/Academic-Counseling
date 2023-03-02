using Dapper;
using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class DoctorRepo : IDoctorRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;
        public DoctorRepo(FOSContext context,IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }

        public Doctor Add(Doctor supervisor)
        {
            var c = context.Doctors.Add(supervisor);
            var res = context.SaveChanges();
            if (res > 0)
                return c.Entity;
            return null;
        }

        public bool Deactivate(string supervisorGUID)
        {
            var supervisor = GetById(supervisorGUID);
            if (supervisor == null) return false;
            supervisor.IsActive = false;
            return Update(supervisor);
        }        
        public bool Activate(string supervisorGUID)
        {
            var supervisor = GetById(supervisorGUID);
            if (supervisor == null) return false;
            supervisor.IsActive = true;
            return Update(supervisor);
        }

        public List<Doctor> GetAll(out int totalCount, SearchCriteria criteria = null)
        {
            var Doctors = context.Doctors;
            return DataFilter<Doctor>.FilterData((DbSet<Doctor>)Doctors, criteria, out totalCount, "Program");
        }

        /// <summary>
        /// Method to get supervisor details
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public Doctor GetById(string GUID)
        {
            return context.Doctors
                .Include(x => x.Program)
                .FirstOrDefault(x => x.Guid == GUID & x.IsActive == true);
        }

        public bool IsEmailReserved(string email)
        {
            return context.Doctors.Any(x => x.Email == email);
        }

        /// <summary>
        /// Method to check the credentials, if it's valid then it will return the supervisor 
        /// else it will return null
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public Doctor Login(string email, string hashedPassword)
        {
            DynamicParameters parameters = new();
            parameters.Add("@Email", email);
            parameters.Add("@Password", hashedPassword);
            using SqlConnection con = new SqlConnection(connectionString);
            return con.Query<Doctor>("Login_Doctor",
                param: parameters,
                commandType: CommandType.StoredProcedure)?.FirstOrDefault();
        }
        public bool Update(Doctor supervisor)
        {
            if (supervisor == null) return false;
            context.Entry(supervisor).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
        public List<Program> GetDoctorPrograms(string guid)
        {
            var doctor = GetById(guid);
            if (doctor == null) return null;
            var param = new DynamicParameters();
            param.Add("@ProgramID", doctor.ProgramId);
            return QueryHelper.Execute<Program>(connectionString, "GetAllSubPrograms", param);
        }
    }
}
