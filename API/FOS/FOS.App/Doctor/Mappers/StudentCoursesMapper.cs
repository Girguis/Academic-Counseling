using AutoMapper;
using FOS.App.Doctors.DTOs;
using FOS.DB.Models;

namespace FOS.App.Doctors.Mappers
{
    public static class StudentCoursesMapper
    {
        /// <summary>
        /// Extension method used to map from StudentCourse model
        /// to StudentCoursesDTO model
        /// </summary>
        public static List<StudentCoursesDTO> ToDTO(this List<StudentCourse> courses,int? academicYearID)
        {
            var config = new MapperConfiguration(c =>
            c.CreateMap<StudentCourse, StudentCoursesDTO>()
            .ForMember(m => m.CourseName, o => o.MapFrom(t => t.Course.CourseName))
            .ForMember(m => m.CourseCode, o => o.MapFrom(t => t.Course.CourseCode))
            .ForMember(m => m.CreditHours, o => o.MapFrom(t => t.Course.CreditHours))
            );
            var mapper = config.CreateMapper();
            List<StudentCoursesDTO> coursesDTO = new List<StudentCoursesDTO>();
            for (int i = 0; i < courses.Count; i++)
            {
                coursesDTO.Add(mapper.Map<StudentCoursesDTO>(courses.ElementAt(i)));
                coursesDTO.ElementAt(i).AcademicYearID = academicYearID;
            }
            return coursesDTO;
        }
    }
}
