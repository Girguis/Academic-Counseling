using AutoMapper;
using FOS.App.Student.DTOs;
using FOS.DB.Models;

namespace FOS.App.Student.Mappers
{
    public static class StudentCourceMapper
    {
        public static StudentCoursesDTO ToDTO(this StudentCourse course)
        {
            try
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
            catch (Exception ex)
            {

            }
            return null;
        }
    }
}
