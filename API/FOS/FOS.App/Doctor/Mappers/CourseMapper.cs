using AutoMapper;
using FOS.App.Doctor.DTOs;
using FOS.DB.Models;

namespace FOS.App.Doctor.Mappers
{
    public static class CourseMapper
    {
        public static CourseDTO ToDTO(this Course course, List<CoursePrerequisite> coursePrerequisite)
        {
            var config = new MapperConfiguration(c =>
                            c.CreateMap<Course, CourseDTO>()
                            );
            var mapper = config.CreateMapper();
            var courseDTO = mapper.Map<CourseDTO>(course);
            courseDTO.Prerequisites = new List<Prerequisite>();
            for (int i = 0; i < coursePrerequisite.Count; i++)
            {
                var currentPreq = coursePrerequisite.ElementAt(i).PrerequisiteCourse;
                courseDTO.Prerequisites.Add(new
                Prerequisite
                {
                    Id = currentPreq.Id,
                    CourseCode = currentPreq.CourseCode,
                    CourseName = currentPreq.CourseName,
                });
            }
            return courseDTO;
        }
    }
}
