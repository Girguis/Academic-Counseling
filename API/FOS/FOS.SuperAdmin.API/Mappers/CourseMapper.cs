using AutoMapper;
using FOS.DB.Models;
using FOS.Doctor.API.Models;

namespace FOS.Doctor.API.Mappers
{
    public static class CourseMapper
    {
        public static Course ToDBCourseModel(this CourseModel courseModel)
        {
            var config = new MapperConfiguration(c =>
                            c.CreateMap<CourseModel, Course>());
            var mapper = config.CreateMapper();
            var course = mapper.Map<Course>(courseModel);
            return course;
        }
    }
}
