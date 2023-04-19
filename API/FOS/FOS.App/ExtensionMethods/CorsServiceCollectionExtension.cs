using Microsoft.Extensions.DependencyInjection;
using System.Net;

namespace FOS.App.ExtensionMethods
{
    /// <summary>
    /// Extension method which is used for allowing calling any API from any Language
    /// </summary>
    public static class CorsServiceCollectionExtension
    {
        public static IServiceCollection LoadCorsServices(this IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddDefaultPolicy(o => o.AllowAnyHeader().AllowAnyOrigin().AllowAnyMethod());
            });
            return services;
        }
    }
}
