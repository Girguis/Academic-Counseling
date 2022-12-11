using AutoMapper;
using FOS.App.Supervisor.DTOs;
using FOS.DB.Models;

namespace FOS.App.Supervisor.Mappers
{
    public static class StudentAcademicMapper
    {
        public static AcademicYearDTO ToDTO(this AcademicYear academicYear,
            string programName,
            List<StudentCoursesDTO> courses,
            decimal? cGpa,
            int? cHours,
            bool finalRecord)
        {
            var config = new MapperConfiguration(c =>
            c.CreateMap<AcademicYear, AcademicYearDTO>()
            .ForMember(m => m.AcademicYear, o => o.MapFrom(t => t.AcademicYear1))
            .ForMember(m => m.Semester, o => o.MapFrom(t => t.Semester))
            );
            var mapper = config.CreateMapper();
            var academicYearDTO = mapper.Map<Supervisor.DTOs.AcademicYearDTO>(academicYear);
            academicYearDTO.Courses = courses;
            academicYearDTO.SemesterHours = courses.Sum(x => x.CreditHours);
            academicYearDTO.PassedSemesterHours = (int)(courses.Where(x => x.Grade != null & x?.Grade?.ToUpper() != "F")?.Sum(x => x.CreditHours));
            var GpaIncludedCourses = courses.Where(x => x.IsIncluded == true & x.IsGpaincluded == true);
            if (GpaIncludedCourses.All(x => x.Grade == null))
                academicYearDTO.SGPA = null;
            else
            {
                academicYearDTO.SGPA = GpaIncludedCourses.Any() ?
                        (decimal?)(GpaIncludedCourses.Sum(x => x.Points * x.CreditHours) / GpaIncludedCourses.Sum(x => x.CreditHours))
                        : null;
            }
            var semesterIncludedHours =
                courses
                .Where(x => x.IsIncluded == true & x.IsGpaincluded == true)
                .Sum(x => x.CreditHours);
            if (academicYearDTO.SGPA != null)
            {
                academicYearDTO.CGPA = Math.Round((decimal)(((academicYearDTO.SGPA * semesterIncludedHours) + (cGpa * cHours)) / (cHours + semesterIncludedHours)), 4);
                academicYearDTO.CHours = semesterIncludedHours + cHours;
                academicYearDTO.SGPA = Math.Round((decimal)academicYearDTO.SGPA, 4);
            }
            else
            {
                if (!finalRecord)
                {
                    academicYearDTO.CGPA = Math.Round((decimal)cGpa, 4);
                    academicYearDTO.CHours = cHours;
                }
                else
                {
                    academicYearDTO.CGPA = null;
                    academicYearDTO.CHours = null;
                    academicYearDTO.PassedSemesterHours = null;
                }
            }
            academicYearDTO.ProgramName = programName;
            return academicYearDTO;
        }
    }
}
