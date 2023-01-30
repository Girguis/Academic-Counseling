using AutoMapper;
using FOS.App.Student.DTOs;
using FOS.DB.Models;

namespace FOS.App.Student.Mappers
{
    public static class OptionalCourseMapper
    {
        public static OptionalCourseDTO ToDTO(this OptionalCourse optionalCourse)
        {
            var config = new MapperConfiguration(c => c.CreateMap<OptionalCourse, OptionalCourseDTO>());
            var mapper = config.CreateMapper();
            var optionalCourseDTO = mapper.Map<OptionalCourseDTO>(optionalCourse);
            return optionalCourseDTO;
        }
    }
}
