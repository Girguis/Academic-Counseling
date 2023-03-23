using FOS.App.Repositories;
using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace FOS.App.ExtensionMethods
{
    /// <summary>
    /// Extension method that includes all dependency injection used in Doctor project
    /// </summary>
    public static class DoctorServiceCollectionExtension
    {
        public static IServiceCollection LoadDoctorServices(this IServiceCollection services)
        {
            services.AddDbContext<FOSContext>(ServiceLifetime.Scoped);
            services.AddScoped<ILogger>(provider => provider.GetRequiredService<ILogger>());
            services.AddScoped<IDoctorRepo, DoctorRepo>();
            services.AddScoped<IStudentRepo, StudentRepo>();
            services.AddScoped<IDatabaseRepo, DatabaseRepo>();
            services.AddScoped<IAcademicYearRepo, AcademicYearRepo>();
            services.AddScoped<IStudentProgramRepo, StudentProgramRepo>();
            services.AddScoped<IBifurcationRepo, BifurcationRepo>();
            services.AddScoped<ICoursePrerequisiteRepo, CoursePrerequisiteRepo>();
            services.AddScoped<ICourseRepo, CourseRepo>();
            services.AddScoped<IDateRepo, DateRepo>();
            services.AddScoped<IProgramRepo, ProgramRepo>();
            services.AddScoped<IStudentProgramRepo, StudentProgramRepo>();
            services.AddScoped<IStudentCoursesRepo, StudentCoursesRepo>();
            services.AddScoped<ICommonQuestionsRepo, CommonQuestionsRepo>();
            services.AddScoped<ISuperAdminRepo, SuperAdminRepo>();
            services.AddScoped<IStatisticsRepo, StatisticsRepo>();
            services.AddScoped<ICourseRequestRepo, CourseRequestRepo>();
            return services;
        }
    }
}