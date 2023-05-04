using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.Configs;
using FOS.Core.IRepositories;
using FOS.DB.Models;

namespace FOS.App.Repositories
{
    public class DateRepo : IDateRepo
    {
        private readonly IDbContext config;

        public DateRepo(IDbContext config)
        {
            this.config = config;
        }
        public bool IsInRegisrationInterval(int id)
        {
            var date = GetDate(id);
            if (date == null)
                return false;
            DateTime currentDate = DateTime.UtcNow.AddHours(Helper.GetUtcOffset());
            return currentDate >= date.StartDate && currentDate <= date.EndDate;
        }
        public bool UpdateDate(int id, DateTime startDate, DateTime endDate)
        {
            var query = string.Format("UPDATE Date SET StartDate = '{0}',EndDate = '{1}' WHERE DateFor = {2}",
                startDate, endDate, id);
            return QueryExecuterHelper.Execute(config.CreateInstance(), query);
        }
        public List<Date> GetDates()
        {
            return QueryExecuterHelper.Execute<Date>(config.CreateInstance(),
                "GetDates", null);
        }
        public Date GetDate(int id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@DateFor", id);
            return QueryExecuterHelper.Execute<Date>(config.CreateInstance(),
                "GetDates",
                parameters).FirstOrDefault();
        }
    }
}
