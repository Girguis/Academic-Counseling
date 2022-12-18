namespace FOS.Core.SearchModels
{
    /// <summary>
    /// each table will have filters in more than 1 column, page number and size, Ordering column (asc,desc)
    /// filters is null by default till user use search
    /// same for OrderByColumn
    /// </summary>
    public sealed class SearchCriteria : Pageable
    {
        public List<SearchBaseModel> Filters { get; set; } = null;
        public string OrderByColumn { get; set; } = null;
        public bool Ascending { get; set; } = false;
    }
}
