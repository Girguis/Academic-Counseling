using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class DateRepo : IDateRepo
    {
        private readonly FOSContext context;

        public DateRepo(FOSContext context)
        {
            this.context = context;
        }
        public bool IsInRegisrationInterval(int id)
        {
            Date date = context.Dates.FirstOrDefault(x => x.DateFor == id);
            if (date == null)
                return false;
            DateTime currentDate = DateTime.UtcNow.AddHours(2);
            return currentDate >= date.StartDate && currentDate <= date.EndDate;
        }
        public bool UpdateDate(int id, DateTime startDate, DateTime endDate)
        {

            var res = context.Database
                .ExecuteSqlRaw("UPDATE Date SET StartDate = {0},EndDate = {1} WHERE DateFor = {2}",
                startDate, endDate, id
                );
            return res > 0;
        }
        public List<Date> GetDates()
        {
            return context.Dates.ToList();
        }
        public Date GetDate(int id)
        {
            return context.Dates.FirstOrDefault(x => x.DateFor == id);
        }
    }
}
