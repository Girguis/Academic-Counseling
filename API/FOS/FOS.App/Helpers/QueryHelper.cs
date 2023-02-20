using Microsoft.Data.SqlClient;
using System.Data;
using System.Net.WebSockets;

namespace FOS.App.Helpers
{
    public class QueryHelper
    {
        public static bool Execute(string connectionString, string storedProcedureName, List<SqlParameter> parameters)
        {
            var res = 0;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("[dbo].[" + storedProcedureName + "]", con);
                cmd.CommandType = CommandType.StoredProcedure;
                for (int i = 0; i < parameters.Count; i++)
                    cmd.Parameters.Add(parameters.ElementAt(i));

                SqlTransaction trans1 = con.BeginTransaction();
                cmd.Transaction = trans1;
                try
                {
                    res = cmd.ExecuteNonQuery();
                    trans1.Commit();
                }
                catch
                {
                    trans1.Rollback();
                }
                con.Close();
            }
            return res > 0;
        }
        public static SqlParameter DataTableToSqlParameter(DataTable dt, string parameterName, string tableTypeName)
        {
            SqlParameter parameter = new SqlParameter("@"+parameterName, dt);
            parameter.TypeName = "[dbo].[" + tableTypeName + "]";
            parameter.SqlDbType = SqlDbType.Structured;
            return parameter;
        }
        public static object ExecuteFunction(string connectionString, string functionName, List<object> parameters)
        {
            object res;
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                var query = "SELECT [dbo].[" + functionName + "](" + string.Join(",", parameters) + ")";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.CommandType = CommandType.Text;
                try
                {
                    res = cmd.ExecuteScalar();
                }
                catch(Exception ex)
                {
                    res = null;
                }
                con.Close();
            }
            return res;
        }
    }
}
