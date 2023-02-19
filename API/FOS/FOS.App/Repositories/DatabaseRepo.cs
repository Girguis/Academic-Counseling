using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class DatabaseRepo : IDatabaseRepo
    {
        private readonly FOSContext context;

        public DatabaseRepo(FOSContext context)
        {
            this.context = context;
        }
        public string Backup()
        {
            var dbName = context.Database.GetDbConnection().Database;
            var fileName = dbName + DateTime.Now.ToString("yyyymmddhhmmss") + ".bak";
            var path = Directory.GetCurrentDirectory();
            path = path.Replace("\\", "/");
            path = path + "/Backup";
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            var filePath = path + "/" + fileName;
            var query = "BACKUP DATABASE " + dbName + " TO DISK = ";
            query += "'" + filePath + "'";
            var res = context.Database.ExecuteSqlRaw(query);
            if (res < 0)
                return filePath;
            return null;
        }

        public bool Restore(string filePath)
        {
            filePath = filePath.Replace("\\", "/");
            var dbName = context.Database.GetDbConnection().Database;
            var query = string.Format("USE master ALTER DATABASE {0} SET SINGLE_USER WITH ROLLBACK IMMEDIATE RESTORE DATABASE {1} FROM DISK = '{2}' WITH REPLACE", dbName, dbName, filePath);
            var res = context.Database.ExecuteSqlRaw(query);
            if (res < 0)
                return true;
            return false;
        }
    }
}
