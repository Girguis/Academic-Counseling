using FOS.Core.Configs;
using Microsoft.Extensions.Configuration;

namespace FOS.App.ExtensionMethods
{
    public static class ConfigureServiceExtension
    {
        public static IConfiguration LoadConfiguration(this IConfiguration configuration)
        {
            ConfigurationsManager.Append(Config.ConnectionString, configuration["ConnectionStrings:FosDB"]);
            return configuration;
        }
    }
}