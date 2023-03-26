using FOS.Core;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;

namespace FOS.App.ExtensionMethods
{
    /// <summary>
    /// Extension method that loads DB connection string and pass it to UseSqlServer to create DbContext instance
    /// </summary>
    public static class DBServiceCollectionExtention
    {
        public static WebApplicationBuilder LoadDBServices(this WebApplicationBuilder builder)
        {
            builder.Services.AddTransient<IDbContext, Core.DbContext>();
            //builder.Services.AddDbContext<FOSContext>(opt => opt.UseSqlServer(builder.Configuration.GetConnectionString("FosDB")));
            return builder;
        }
    }
}
