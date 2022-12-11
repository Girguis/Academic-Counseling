using Microsoft.Extensions.DependencyInjection;

namespace FOS.App.ExtensionMethods
{
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
