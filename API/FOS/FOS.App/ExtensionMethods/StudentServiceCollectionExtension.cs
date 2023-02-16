using FOS.App.Repositories;
using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace FOS.App.ExtensionMethods
{
    /// <summary>
    /// Extension method that includes all dependency injection used in Student project
    /// </summary>
    public static class ServiceCollectionExtension
    {
        public static IServiceCollection LoadStudentServices(this IServiceCollection services)
        {

            services.AddDbContext<FOSContext>(ServiceLifetime.Scoped);
            services.AddScoped<IStudentRepo, StudentRepo>();
            services.AddScoped<IStudentCoursesRepo, StudentCoursesRepo>();
            services.AddScoped<IAcademicYearRepo, AcademicYearRepo>();
            services.AddScoped<IBifurcationRepo, BifurcationRepo>();
            services.AddScoped<IProgramRepo, ProgramRepo>();
            services.AddScoped<IElectiveCourseDistributionRepo, ElectiveCourseDistributionsRepo>();
            services.AddScoped<IDateRepo, DateRepo>();
            services.AddScoped<IProgramDistributionRepo, ProgramDistributionRepo>();
            services.AddScoped<ILogger>(provider => provider.GetRequiredService<ILogger>());
            services.AddScoped<ICommonQuestionsRepo, CommonQuestionsRepo>();
            services.AddScoped<IStudentProgramRepo, StudentProgramRepo>();
            return services;
        }
    }
}
