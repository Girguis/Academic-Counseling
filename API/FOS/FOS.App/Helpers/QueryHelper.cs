using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;

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
            SqlParameter parameter = new SqlParameter("@" + parameterName, dt);
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
                catch (Exception)
                {
                    res = null;
                }
                con.Close();
            }
            return res;
        }
        public static List<T> Execute<T>(string connectionString, string storedProcedureName, DynamicParameters parameters)
        {
            using SqlConnection con = new SqlConnection(connectionString);
            if(parameters == null)
                return con.Query<T>(storedProcedureName, commandType: CommandType.StoredProcedure)?.ToList();
            return con.Query<T>(storedProcedureName, param: parameters, commandType: CommandType.StoredProcedure)?.ToList();
        }
    }
}

//var objects = new List<object>();
//using (SqlConnection con = new SqlConnection(connectionString))
//{
//    con.Open();
//    SqlCommand cmd = new SqlCommand("[dbo].[" + storedProcedureName + "]", con);
//    cmd.CommandType = CommandType.StoredProcedure;
//    for (int i = 0; i < parameters.Count; i++)
//        cmd.Parameters.Add(parameters.ElementAt(i));

//    SqlTransaction trans1 = con.BeginTransaction();
//    cmd.Transaction = trans1;
//    try
//    {
//        var reader = cmd.ExecuteReader();
//        var cols = reader.GetColumnSchema();
//        while (reader.Read())
//        {
//            dynamic obj = new ExpandoObject();
//            for (int i = 0; i < cols.Count; i++)
//            {
//                var col = cols.ElementAt(i);
//                var datatype = col.DataType.Name;
//                dynamic val = 0;
//                if (!reader.IsDBNull(col.ColumnName))
//                {
//                    if (datatype == "Int16")
//                        val = reader.GetInt16(col.ColumnName);
//                    else if (datatype == "Int32")
//                        val = reader.GetInt32(col.ColumnName);
//                    else if (datatype == "Int64")
//                        val = reader.GetInt64(col.ColumnName);
//                    else if (datatype == "Double")
//                        val = reader.GetDouble(col.ColumnName);
//                    else if (datatype == "Boolean")
//                        val = reader.GetBoolean(col.ColumnName);
//                    else if (datatype == "Float")
//                        val = reader.GetFloat(col.ColumnName);
//                    else if (datatype == "String")
//                        val = reader.GetString(col.ColumnName);
//                    else if (datatype == "Byte")
//                        val = reader.GetByte(col.ColumnName);
//                    else if (datatype == "Bytes")
//                        val = reader.GetByte(col.ColumnName);
//                    else if (datatype == "Char")
//                        val = reader.GetChar(col.ColumnName);
//                    else if (datatype == "Decimal")
//                        val = reader.GetDecimal(col.ColumnName);
//                }
//                else
//                    val = null;
//                ((IDictionary<string, object>)obj).Add(col.ColumnName, val);
//            }
//            objects.Add(obj);
//        }
//        reader.Close();
//    }
//    finally
//    {
//        con.Close();
//    }
//}
//return JsonConvert.DeserializeObject<List<T>>(JsonConvert.SerializeObject(objects));