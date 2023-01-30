using FOS.Core.IRepositories.Student;
using FOS.DB.Models;

namespace FOS.App.Student.Repositories
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
    }
}
