using FOS.App.Student.Repositories;
using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.Extensions.DependencyInjection;
using IStudentRepo = FOS.Core.IRepositories.Student.IStudentRepo;
using StudentRepo = FOS.App.Student.Repositories.StudentRepo;

namespace FOS.App.ExtensionMethods
{
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
            //services.AddSingleton<ILogger>(provider => provider.GetRequiredService<ILogger>());
            return services;
        }
    }
}
