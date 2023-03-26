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
    }
}
