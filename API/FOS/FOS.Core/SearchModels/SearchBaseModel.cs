namespace FOS.Core.SearchModels
{
    /// <summary>
    /// Model used for filtration
    /// i.e if you are seraching for a student by Academic ID
    /// Key will be "AcademiID", Operator will be "=", value will be any Academic ID "190114"
    /// </summary>
    public sealed class SearchBaseModel
    {
        public string Key { get; set; }
        public string Operator { get; set; } = "=";
        public object? Value { get; set; }
    }
}
