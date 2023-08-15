using FOS.Core.Configs;
using Microsoft.Extensions.Configuration;

namespace FOS.App.ExtensionMethods
{
    public static class ConfigureServiceExtension
    {
        public static IConfiguration LoadConfiguration(this IConfiguration configuration)
        {
            ConfigurationsManager.Append(Config.ConnectionString, configuration["ConnectionStrings:FosDB"]);
            ConfigurationsManager.Append(Config.UtcOffset, configuration["UtcOffset"]);
            ConfigurationsManager.Append(Config.SummerRegHours, configuration["Summer:HoursToRegister"]);
            ConfigurationsManager.Append(Config.HoursToSkip, configuration["HoursToSkip"]);
            ConfigurationsManager.Append(Config.LevelsRangeForCourseRegistraion, configuration["LevelsRangeForCourseRegistraion"]);
            ConfigurationsManager.Append(Config.HoursForCourseOpeningForGraduation, configuration["HoursForCourseOpeningForGraduation"]);
            ConfigurationsManager.Append(Config.JwtKey, configuration["Jwt:Key"]);
            ConfigurationsManager.Append(Config.JwtIssuer, configuration["Jwt:Issuer"]);
            ConfigurationsManager.Append(Config.JwtAudience, configuration["Jwt:Audience"]);
            return configuration;
        }
    }
}