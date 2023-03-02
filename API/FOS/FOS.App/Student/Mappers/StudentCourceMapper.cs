using AutoMapper;
using FOS.App.Students.DTOs;
using FOS.DB.Models;

namespace FOS.App.Students.Mappers
{
    public static class StudentCourceMapper
    {
        /// <summary>
        /// Extension method used to map course model (model from database)
        /// to StudentCoursesDTO model
        /// </summary>
        public static StudentCoursesDTO ToDTO(this StudentCourse course)
        {
            var config = new MapperConfiguration(c =>
            c.CreateMap<StudentCourse, StudentCoursesDTO>()
            .ForMember(m => m.CourceName, o => o.MapFrom(t => t.Course.CourseName))
            .ForMember(m => m.CourceCode, o => o.MapFrom(t => t.Course.CourseCode))
            .ForMember(m => m.CourceCredits, o => o.MapFrom(t => t.Course.CreditHours))
            );
            var mapper = config.CreateMapper();
            var courceDto = mapper.Map<StudentCoursesDTO>(course);

            return courceDto;
        }
    }
}
