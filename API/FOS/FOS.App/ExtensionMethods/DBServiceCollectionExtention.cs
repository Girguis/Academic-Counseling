using FOS.DB.Models;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace FOS.App.ExtensionMethods
{
    public static class DBServiceCollectionExtention
    {
        public static WebApplicationBuilder LoadDBServices(this WebApplicationBuilder builder)
        {
            builder.Services.AddDbContext<FOSContext>(opt => opt.UseSqlServer(builder.Configuration.GetConnectionString("FosDB")));
            return builder;
        }
    }
}
