using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;

namespace FOS.App.Repositories
{
    public class AcademicYearRepo : IAcademicYearRepo
    {
        private readonly IDbContext config;

        public AcademicYearRepo(IDbContext config)
        {
            this.config = config;
        }
        /// <summary>
        /// Method used to add new Academic year to DB
        /// </summary>
        /// <returns></returns>
        public bool StartNewYear()
        {
            AcademicYear currentAcademicYear = GetCurrentYear();
            var newSemester = (byte)((currentAcademicYear.Semester % 3.0) + 1);
            string newYear = currentAcademicYear.AcademicYear1;
            string AcademicCodeResetQuery = null;
            if (newSemester == 1)
            {
                _ = int.TryParse(currentAcademicYear?.AcademicYear1?.ToString()?.Split("/")[0], out int year);
                newYear = year + 1 + "/" + (year + 2);
                AcademicCodeResetQuery = "ALTER SEQUENCE AcademicCodeSeq RESTART WITH "+
                    DateTime.Now.Year.ToString()[2..] + "0000;";
            }
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "StartNewAcademicYear",
                new List<SqlParameter>
                {
                    new SqlParameter("@Semester", newSemester),
                    new SqlParameter("@AcademicYear", newYear),
                    new SqlParameter("@CodeResetQuery", AcademicCodeResetQuery)
                });
        }
        /// <summary>
        /// Method used to get current academic year details
        /// </summary>
        /// <returns></returns>
        public AcademicYear GetCurrentYear()
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@GetCurrentYear", 1);
            return QueryExecuterHelper.Execute<AcademicYear>(config.CreateInstance()
                , "GetAcademicYears"
                , parameters).FirstOrDefault();
        }
        public List<AcademicYear> GetAcademicYearsList()
        {
            return QueryExecuterHelper.Execute<AcademicYear>(config.CreateInstance()
                , "GetAcademicYears");
        }
    }
}
