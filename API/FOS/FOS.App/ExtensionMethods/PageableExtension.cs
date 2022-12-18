namespace FOS.App.ExtensionMethods
{
    /// <summary>
    /// Extension method used for getting some records from a list by using page number and size
    /// </summary>
    internal static class PageableExtension
    {
        public static IQueryable<T> Pageable<T>(this IQueryable<T> source,
            int? pageNumber = null,
            int? pageSize = null)
        {
            if (!pageNumber.HasValue && !pageSize.HasValue)
                return source;

            int _pageSize = pageSize < 1 ? 20 : pageSize.Value;
            int _pageNumber = (!pageNumber.HasValue || pageNumber - 1 < 0)
                ? 0
                : (pageNumber.Value - 1);

            return source.Skip(_pageNumber * _pageSize).Take(_pageSize);
        }
    }
}
