using AutoMapper;
using FOS.App.Doctor.DTOs;
    
namespace FOS.App.Doctor.Mappers
{
    public static class StudentAcademicReportMapper
    {
        /// <summary>
        /// Extension method used to map from Student, AcademicYearDTO and programName
        /// to StudentAcademicReportDTO model
        /// </summary>
        public static StudentAcademicReportDTO ToDTO(this DB.Models.Student student, List<AcademicYearDTO> academicYears, string programName)
        {
            var config = new MapperConfiguration(c =>
            c.CreateMap<DB.Models.Student, StudentAcademicReportDTO>()
            .ForMember(o => o.Cgpa, x => x.MapFrom(z => z.Cgpa))
            );
            var mapper = config.CreateMapper();
            var studentReport = mapper.Map<StudentAcademicReportDTO>(student);
            studentReport.academicYearsDetails = academicYears;
            studentReport.ProgramName = programName;
            return studentReport;
        }
    }
}
