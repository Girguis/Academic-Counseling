using FOS.App.ExtensionMethods;
using FOS.Core.SearchModels;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Helpers
{
    public class DataFilter<T> where T : class
    {
        public static List<T> FilterData(DbSet<T> dataToFilter, SearchCriteria criteria, out int totalCount,string includes = "")
        {
            if (criteria == null)
            {
                List<T> dataLst = string.IsNullOrEmpty(includes) ? dataToFilter?.ToList() : dataToFilter.Include(includes)?.ToList();
                totalCount = dataLst.Count();
                return dataLst;
            }
            var data = string.IsNullOrEmpty(includes) ? dataToFilter.AsQueryable() : dataToFilter.Include(includes).AsQueryable();
            data = data.Search(criteria.Filters);
            data = data.Order(criteria.OrderByColumn, criteria.Ascending);
            totalCount = data.Count();
            data = data.Pageable(criteria.PageNumber, criteria.PageSize);
            return data?.ToList();
        }
    }
}
