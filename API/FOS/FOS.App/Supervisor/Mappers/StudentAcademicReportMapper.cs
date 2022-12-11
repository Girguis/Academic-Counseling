using AutoMapper;
using FOS.App.Supervisor.DTOs;

namespace FOS.App.Supervisor.Mappers
{
    public static class StudentAcademicReportMapper
    {
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
