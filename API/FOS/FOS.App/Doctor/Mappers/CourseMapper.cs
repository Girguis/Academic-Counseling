using AutoMapper;
using FOS.App.Doctor.DTOs;
using FOS.DB.Models;

namespace FOS.App.Doctor.Mappers
{
    public static class CourseMapper
    {
        public static CourseDTO ToDTO(this Course course)
        {
            var config = new MapperConfiguration(c =>
                            c.CreateMap<Course, CourseDTO>()
                            );
            var mapper = config.CreateMapper();
            var courseDTO = mapper.Map<CourseDTO>(course);
            return courseDTO;
        }
    }
}
