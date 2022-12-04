using FOS.App.Student.Repositories;
using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FOS.App.ExtensionMethods
{
    public static class ServiceCollectionExtension
    {
        public static IServiceCollection LoadServices(this IServiceCollection services)
        {
            services.AddDbContext<FOSContext>(ServiceLifetime.Scoped);
            services.AddScoped<IStudentRepo, StudentRepo>();
            services.AddScoped<IStudentCoursesRepo, StudentCoursesRepo>();
            services.AddScoped<IAcademicYearRepo, AcademicYearRepo>();
            services.AddScoped<IStudentDesiresRepo, StudentDesiresRepo>();
            //services.AddSingleton<ILogger>(provider => provider.GetRequiredService<ILogger>());
            return services;
        }
    }
}
