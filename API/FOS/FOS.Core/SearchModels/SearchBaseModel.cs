namespace FOS.Core.SearchModels
{
    public sealed class SearchBaseModel
    {
        public string Key { get; set; }
        public string Operator { get; set; } = "=";
        public object Value { get; set; }
    }
}
