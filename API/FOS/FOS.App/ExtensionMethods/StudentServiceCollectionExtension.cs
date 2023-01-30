using FOS.App.Student.Repositories;
using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using IStudentRepo = FOS.Core.IRepositories.Student.IStudentRepo;
using StudentRepo = FOS.App.Student.Repositories.StudentRepo;

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
            services.AddScoped<IOptionalCourseRepo, OptionalCourseRepo>();
            services.AddScoped<IDateRepo, DateRepo>();
            services.AddScoped<ILogger>(provider => provider.GetRequiredService<ILogger>());
            return services;
        }
    }
}
