using AutoMapper;
using FOS.App.Students.DTOs;
using FOS.DB.Models;

namespace FOS.App.Students.Mappers
{
    public static class CourseRegistrationMapper
    {
        public static CourseRegistrationDTO ToCourseRegisrationDTO(this ProgramCourse programCourse)
        {
            var config = new MapperConfiguration(c => c.CreateMap<ProgramCourse, CourseRegistrationDTO>()
            .ForMember(m => m.Id, o => o.MapFrom(t => t.CourseId))
            .ForMember(m => m.CourseCode, o => o.MapFrom(t => t.Course.CourseCode))
            .ForMember(m => m.CourseName, o => o.MapFrom(t => t.Course.CourseName))
            .ForMember(m => m.LectureHours, o => o.MapFrom(t => t.Course.LectureHours))
            .ForMember(m => m.CreditHours, o => o.MapFrom(t => t.Course.CreditHours))
            .ForMember(m => m.LabHours, o => o.MapFrom(t => t.Course.LabHours))
            .ForMember(m => m.SectionHours, o => o.MapFrom(t => t.Course.SectionHours))
            .ForMember(m => m.Level, o => o.MapFrom(t => t.Course.Level))
            .ForMember(m => m.Semester, o => o.MapFrom(t => t.Course.Semester))
            );
            var mapper = config.CreateMapper();
            CourseRegistrationDTO courseDTOs = new CourseRegistrationDTO();
                courseDTOs = mapper.Map<CourseRegistrationDTO>(programCourse);
            return courseDTOs;
        }
    }
}
