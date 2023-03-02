using AutoMapper;
using FOS.App.Students.DTOs;
using FOS.DB.Models;

namespace FOS.App.Students.Mappers
{
    public static class OptionalCourseMapper
    {
        public static ElectiveCourseDTO ToDTO(this ElectiveCourseDistribution optionalCourse)
        {
            var config = new MapperConfiguration(c => c.CreateMap<ElectiveCourseDistribution, ElectiveCourseDTO>());
            var mapper = config.CreateMapper();
            var optionalCourseDTO = mapper.Map<ElectiveCourseDTO>(optionalCourse);
            return optionalCourseDTO;
        }
    }
}
