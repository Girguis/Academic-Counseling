using Dapper;
using FOS.Core;
using FOS.Core.IRepositories;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class DatabaseRepo : IDatabaseRepo
    {
        private readonly IDbContext config;

        public DatabaseRepo(IDbContext config)
        {
            this.config = config;
        }
        public string Backup()
        {
            using var con = config.CreateInstance();
            var dbName = con.Database;
            var fileName = dbName + DateTime.Now.ToString("yyyymmddhhmmss") + ".bak";
            var path = Directory.GetCurrentDirectory();
            path = path.Replace("\\", "/");
            path = path + "/Backup";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            var filePath = path + "/" + fileName;
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@dbName", dbName);
            parameters.Add("@Path", filePath);
            var res = con.Execute("BackUpDatabase",
                parameters,
                commandType: System.Data.CommandType.StoredProcedure);
            if (res < 0)
                return filePath;
            return null;
        }
        public bool Restore(string filePath)
        {
            int res = 0;
            using var con = config.CreateInstance();
            con.Open();
            var dbName = con.Database;
            var anotherDb = con.Query<string>("SELECT name from sys.databases").FirstOrDefault();
            con.ChangeDatabase(anotherDb);
            // set database to single user
            var sql = @"declare @database varchar(max) = quotename(@databaseName)
                                EXEC('ALTER DATABASE ' + @database + ' SET SINGLE_USER WITH ROLLBACK IMMEDIATE')";
            using (var command = new SqlCommand(sql, con))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.AddWithValue("@databaseName", dbName);

                res += command.ExecuteNonQuery();
            }

            sql = @"RESTORE DATABASE @databaseName 
                    FROM DISK = @localDatabasePath 
                    WITH REPLACE";

            using (var command = new SqlCommand(sql, con))
            {
                command.CommandTimeout = 7200;
                command.CommandType = CommandType.Text;
                command.Parameters.AddWithValue("@databaseName", dbName);
                command.Parameters.AddWithValue("@localDatabasePath", filePath);
                res += command.ExecuteNonQuery();
            }

            // set database to multi user
            sql = @"declare @database varchar(max) = quotename(@databaseName)
                    EXEC('ALTER DATABASE ' + @database + ' SET MULTI_USER')";
            using (var command = new SqlCommand(sql, con))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.AddWithValue("@databaseName", dbName);
                res += command.ExecuteNonQuery();
            }
            return res < -2;
        }

        //public bool Restore(string filePath)
        //{
        //    using var con = config.CreateInstance();
        //    filePath = filePath.Replace("\\", "/");
        //    var dbName = con.Database;
        //    var query = string.Concat("USE Test ALTER DATABASE ", dbName,
        //        " SET SINGLE_USER ",
        //        "WITH ROLLBACK IMMEDIATE ",
        //        "RESTORE DATABASE ", dbName,
        //        " FROM DISK = '", filePath, "' WITH REPLACE");
        //    DynamicParameters parameters  = new DynamicParameters();
        //    parameters.Add("@Query", query);
        //    var res = con.Execute("QueryExecuter", parameters, commandType: System.Data.CommandType.StoredProcedure);
        //    return res > 0;
        //}
    }
}
