using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using Microsoft.Data.SqlClient;
using System.Data;

namespace FOS.App.Repositories
{
    public class DoctorRepo : IDoctorRepo
    {
        private readonly IDbContext config;
        public DoctorRepo(IDbContext config)
        {
            this.config = config;
        }

        public bool Add(DoctorAddParamModel doctor)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddDoctor",
                new List<SqlParameter>()
            {
                    new SqlParameter("@GUID",Guid.NewGuid().ToString()),
                    new SqlParameter("@Name",doctor.Name),
                    new SqlParameter("@Email",doctor.Email),
                    new SqlParameter("@Password",Helper.HashPassowrd(doctor.Password)),
                    new SqlParameter("@ProgramID",doctor.ProgramId),
                    new SqlParameter("@Type",doctor.Type),
                    new SqlParameter("@CreatedOn",DateTime.UtcNow.AddHours(2))
            });
        }

        public bool Deactivate(string guid)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "ToggleDoctorAccount",
                new List<SqlParameter>()
                {
                    new SqlParameter("@GUID",guid),
                    new SqlParameter("@IsActive",false)
                }
                );
        }
        public bool Activate(string guid)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                    "ToggleDoctorAccount",
                    new List<SqlParameter>()
                    {
                        new SqlParameter("@GUID",guid),
                        new SqlParameter("@IsActive",true)
                    }
                );
        }

        public List<DoctorOutModel> GetAll(out int totalCount, SearchCriteria criteria = null)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Name", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "name")?.Value?.ToString());
            parameters.Add("@Email", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "email")?.Value?.ToString());
            parameters.Add("@ProgramID", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "programid")?.Value?.ToString());
            parameters.Add("@Type", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "type")?.Value?.ToString());
            parameters.Add("@IsActive", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isactive")?.Value?.ToString());
            parameters.GetPageParameters(criteria, "d.ID");
            using var con = config.CreateInstance();
            var doctors = con.Query<DoctorOutModel>("GetDoctors", parameters, commandType: CommandType.StoredProcedure)?.ToList();
            try { totalCount = parameters.Get<int>("TotalCount"); }
            catch { totalCount = doctors.Count; }
            return doctors;
        }

        /// <summary>
        /// Method to get supervisor details
        /// </summary>
        /// <param name="GUID"></param>
        /// <returns></returns>
        public DoctorOutModel GetById(string GUID, bool isActive = true)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@GUID", GUID);
            parameters.Add("@IsActive", isActive);
            return QueryExecuterHelper.Execute<DoctorOutModel>(config.CreateInstance(),
                "GetDoctorByGuid",
                parameters).FirstOrDefault();
        }

        public bool IsEmailReserved(string email)
        {
            return (bool)QueryExecuterHelper.ExecuteFunction(config.CreateInstance(),
                "IsDoctorEmailExist",
                "'" + email + "'");
        }

        /// <summary>
        /// Method to check the credentials, if it's valid then it will return the supervisor 
        /// else it will return null
        /// </summary>
        /// <param name="email"></param>
        /// <param name="hashedPassword"></param>
        /// <returns></returns>
        public DoctorOutModel Login(string email, string hashedPassword)
        {
            DynamicParameters parameters = new();
            parameters.Add("@Email", email);
            parameters.Add("@Password", hashedPassword);
            using var con = config.CreateInstance();
            return con.Query<DoctorOutModel>("Login_Doctor",
                param: parameters,
                commandType: CommandType.StoredProcedure)?.FirstOrDefault();
        }
        public bool Update(string guid, DoctorUpdateParamModel doctor)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "UpdateDoctor",
                new List<SqlParameter>()
                {
                    new SqlParameter("@Guid",guid),
                    new SqlParameter("@Name",doctor.Name),
                    new SqlParameter("@Email",doctor.Email),
                    new SqlParameter("@Type",doctor.Type),
                    new SqlParameter("@ProgramID",doctor.ProgramId)
                });
        }

        public bool ChangePassword(string guid, string password)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "ChangeDoctorPassword",
                new List<SqlParameter>()
                {
                    new SqlParameter("@guid",guid),
                    new SqlParameter("@password",Helper.HashPassowrd(password))
                });
        }
    }
}
