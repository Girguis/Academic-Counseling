namespace FOS.Core.SearchModels
{
    public sealed class SearchCriteria : Pageable
    {
        public List<SearchBaseModel> Filters { get; set; } = null;
        public string OrderByColumn { get; set; } = null;
        public bool Ascending { get; set; } = false;
    }
}
