using FOS.App.Supervisor.Repositories;
using FOS.Core.IRepositories.Supervisor;
using FOS.DB.Models;
using Microsoft.Extensions.DependencyInjection;

namespace FOS.App.ExtensionMethods
{
    public static class SupervisorServiceCollectionExtention
    {
        public static IServiceCollection LoadSupervisorServices(this IServiceCollection services)
        {
            services.AddDbContext<FOSContext>(ServiceLifetime.Scoped);
            services.AddScoped<ISupervisorRepo, SupervisorRepo>();
            services.AddScoped<IStudentRepo, StudentRepo>();
            return services;
        }
    }
}
