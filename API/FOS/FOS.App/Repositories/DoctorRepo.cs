using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.Configs;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models;
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
                    new SqlParameter("@CreatedOn",DateTime.UtcNow.AddHours(Helper.GetUtcOffset()))
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
            parameters.Add("@ProgramGuid", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "programid")?.Value?.ToString());
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
        public DoctorLoginOutModel Login(string email, string hashedPassword)
        {
            DynamicParameters parameters = new();
            parameters.Add("@Email", email);
            parameters.Add("@Password", hashedPassword);
            using var con = config.CreateInstance();
            return con.Query<DoctorLoginOutModel>("Login_Doctor",
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

        public bool AssignSupervisorsToStudentsRandomly()
        {
            using var con = config.CreateInstance();
            var programs = con.Query<int>("SELECT ID FROM Program WHERE SuperProgramID IS NULL", commandType: CommandType.Text);
            string baseQuery = "UPDATE Student SET SupervisorID = {0} WHERE ID IN ({1}); ";
            List<string> queries = new();
            Parallel.For(0, programs.Count(), i =>
            {
                string query = "";
                using var con2 = config.CreateInstance();
                var subProgramsList = con2.Query<int>("WITH ParentChilds AS (SELECT ID FROM Program WHERE ID = " + programs.ElementAt(i).ToString() + " UNION ALL SELECT child.ID FROM Program child JOIN ParentChilds pc  ON pc.ID = child.superProgramID) SELECT *FROM ParentChilds;", commandType: CommandType.Text);
                var subPrograms = string.Join(",", subProgramsList);
                var students = con2.Query<int>("SELECT ID FROM Student WHERE IsGraduated = 0 AND IsActive = 1 AND CurrentProgramID IN (" + subPrograms + ") ORDER BY NEWID()", commandType: CommandType.Text);
                var doctors = con2.Query<int>("SELECT ID FROM Doctor WHERE Type = " + ((int)DoctorTypesEnum.Supervisor).ToString() + " AND IsActive = 1 AND ProgramID IN (" + subPrograms + ") ORDER BY NEWID()", commandType: CommandType.Text);
                con2.Close();
                var stdsCount = students.Count();
                var docsCount = doctors.Count();
                if (stdsCount > 0 && docsCount > 0)
                {
                    int index = 0;
                    int studentsCountPerDoctor = stdsCount / docsCount;
                    for (; index < docsCount; index++)
                        query += string.Format(baseQuery,
                            doctors.ElementAt(index),
                            string.Join(",", students.Skip(studentsCountPerDoctor * index).Take(studentsCountPerDoctor)));
                    var reminder = stdsCount % docsCount;
                    int j = 0, counter = 0;
                    while (reminder != 0)
                    {
                        query += string.Format(baseQuery,
                            doctors.ElementAt(j),
                            string.Join(",", students.Skip(counter + (index - 1)).Take(1)));
                        counter++;
                        j = j++ % docsCount;
                        reminder--;
                    }
                    queries.Add(query);
                }
            });
            string queryToBeExecuted = string.Join(" ", queries);
            if (string.IsNullOrEmpty(queryToBeExecuted))
                return false;
            return QueryExecuterHelper.Execute(config.CreateInstance(), queryToBeExecuted);
        }

        public List<General> GetDoctorsAsDropDown()
        {
            return QueryExecuterHelper.Execute<General>
                (config.CreateInstance(),
                "GetAllDoctorsAsDropDown");
        }
    }
}
