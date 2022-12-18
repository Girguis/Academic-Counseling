using Newtonsoft.Json;

namespace FOS.App.Configs
{
    /// <summary>
    /// Instead of hard coding filters in source code
    /// it wil be stored in FilterConfiguration.json 
    /// which include a list of operators with it's coresponding function in C# i.e
    /// "operator": ">",
    /// "method": "GreaterThan"
    /// </summary>
    internal class FilterConfigurationReader
    {
        private static List<FilterOperator> Filters { get; set; }
        private static List<FilterOperator> Read()
        {
            if (Filters != null && Filters.Count > 0)
                return Filters;

            var path = Directory.GetFiles(AppContext.BaseDirectory, "FilterConfiguration.json", SearchOption.AllDirectories).FirstOrDefault();
            if (string.IsNullOrEmpty(path) || !File.Exists(path))
                return new List<FilterOperator>();

            var allText = File.ReadAllText(path);
            var obj = JsonConvert.DeserializeObject<FilterConfiguration>(allText);
            Filters = obj?.Filters;
            return Filters;
        }

        public static FilterOperator Get(string op)
        {
            var filters = Read();
            return filters?.FirstOrDefault(o => o.Operator == op);
        }
    }

    internal class FilterConfiguration
    {
        [JsonProperty("filters")]
        public List<FilterOperator> Filters { get; set; }
    }

    internal class FilterOperator
    {
        [JsonProperty("operator")]
        public string Operator { get; set; }

        [JsonProperty("method")]
        public string Method { get; set; }
    }
}
