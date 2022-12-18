using Microsoft.AspNetCore.Mvc.Versioning;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.OpenApi.Models;

namespace FOS.App.ExtensionMethods
{
    /// <summary>
    /// Extension method used for versioning and giving other details to swagger 
    /// </summary>
    public static class SwaggerVersioningServiceCollectionExtension
    {
        public static IServiceCollection LoadSwaggerVersioningServices(this IServiceCollection services, string version, string title, int majorVersion, int minorVersion)
        {
            services.AddSwaggerGen(x =>
            {
                x.SwaggerDoc(version, new OpenApiInfo()
                {
                    Version = version,
                    Title = title
                });
            });
            services.AddApiVersioning(o =>
            {
                o.AssumeDefaultVersionWhenUnspecified = true;
                o.DefaultApiVersion = new Microsoft.AspNetCore.Mvc.ApiVersion(majorVersion, minorVersion);
                o.ReportApiVersions = true;
                o.ApiVersionReader = ApiVersionReader.Combine(
                    new QueryStringApiVersionReader("api-version"),
                    new HeaderApiVersionReader("X-Version"),
                    new MediaTypeApiVersionReader("ver"));
            });
            return services;
        }
    }
}
