using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IDateRepo
    {
        bool IsInRegisrationInterval(int id);
        bool UpdateDate(int id, DateTime startDate, DateTime endDate);
        List<Date> GetDates();
        Date GetDate(int id);
    }
}
