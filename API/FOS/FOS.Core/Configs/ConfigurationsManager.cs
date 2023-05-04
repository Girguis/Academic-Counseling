namespace FOS.Core.Configs
{
    public static class ConfigurationsManager
    {
        private static Dictionary<Config, string> dict = new Dictionary<Config, string>();
        public static void Append(Config config, string value)
        {
            if (!dict.ContainsKey(config))
                dict.Add(config, value);
        }

        public static string TryGet(Config config)
        {
            dict.TryGetValue(config, out string value);
            return value;
        }
        public static int TryGetNumber(Config config,int defaultValue = 0)
        {
            dict.TryGetValue(config, out string value);
            if(!int.TryParse(value, out int parsedValue))
                return defaultValue;
            return parsedValue;
        }
    }
}
