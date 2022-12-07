using AutoMapper;
using FOS.DB.Models;

namespace FOS.App.Supervisor.Mappers
{
    public static class StudentCoursesMapper
    {
        public static List<Supervisor.DTOs.StudentCoursesDTO> ToDTO(this List<StudentCourse> courses)
        {
            try
            {
                var config = new MapperConfiguration(c =>
                c.CreateMap<StudentCourse, Supervisor.DTOs.StudentCoursesDTO>()
                .ForMember(m => m.CourseName, o => o.MapFrom(t => t.Course.CourseName))
                .ForMember(m => m.CourseCode, o => o.MapFrom(t => t.Course.CourseCode))
                .ForMember(m => m.CreditHours, o => o.MapFrom(t => t.Course.CreditHours))
                );
                var mapper = config.CreateMapper();
                List<Supervisor.DTOs.StudentCoursesDTO> coursesDTO = new List<DTOs.StudentCoursesDTO>();
                for (int i = 0; i < courses.Count; i++)
                {
                    coursesDTO.Add(mapper.Map<DTOs.StudentCoursesDTO>(courses.ElementAt(i)));
                }
                return coursesDTO;
            }
            catch (Exception ex)
            {

            }
            return null;
        }
    }
}
