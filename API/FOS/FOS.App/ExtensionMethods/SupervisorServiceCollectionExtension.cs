using FOS.DB.Models;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using FOS.Core.IRepositories;
using FOS.App.Repositories;

namespace FOS.App.ExtensionMethods
{
    /// <summary>
    /// Extension method that includes all dependency injection used in Supervisor project
    /// </summary>
    public static class SupervisorServiceCollectionExtension
    {
        public static IServiceCollection LoadSupervisorServices(this IServiceCollection services)
        {
            services.AddDbContext<FOSContext>(ServiceLifetime.Scoped);
            services.AddScoped<ILogger>(provider => provider.GetRequiredService<ILogger>());
            services.AddScoped<ISupervisorRepo, SupervisorRepo>();
            services.AddScoped<IStudentRepo, StudentRepo>();
            services.AddScoped<IDatabaseRepo, DatabaseRepo>();
            services.AddScoped<IAcademicYearRepo, AcademicYearRepo>();
            services.AddScoped<IStudentProgramRepo, StudentProgramRepo>();
            services.AddScoped<IBifurcationRepo, BifurcationRepo>();
            services.AddScoped<ICoursePrerequisiteRepo, CoursePrerequisiteRepo>();
            services.AddScoped<ICourseRepo, CourseRepo>();
            services.AddScoped<IDateRepo, DateRepo>();
            return services;
        }
    }
}
