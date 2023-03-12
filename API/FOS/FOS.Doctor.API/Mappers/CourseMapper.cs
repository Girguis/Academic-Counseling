using AutoMapper;
using FOS.DB.Models;
using FOS.Doctors.API.Models;

namespace FOS.Doctors.API.Mappers
{
    public static class CourseMapper
    {
        public static Course ToDBCourseModel(this CourseModel courseModel,int id = 0) 
        {
            var config = new MapperConfiguration(c =>
                            c.CreateMap<CourseModel, Course>());
            var mapper = config.CreateMapper();
            var course = mapper.Map<Course>(courseModel);
            course.Id = id;
            return course;
        }
    }
}
