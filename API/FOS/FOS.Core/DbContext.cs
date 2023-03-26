using FOS.Core.Configs;
using Microsoft.Data.SqlClient;

namespace FOS.Core
{
    public sealed class DbContext : IDbContext
    {
        public SqlConnection Connection { get; private set; }
        public SqlConnection CreateInstance()
        {
            if (Connection == null)
            {
                var connectionString = ConfigurationsManager.TryGet(Config.ConnectionString);
                return new SqlConnection(connectionString);
            }
            return Connection;
        }
    }

    public interface IDbContext
    {
        SqlConnection Connection { get; }
        SqlConnection CreateInstance();
    }
}
