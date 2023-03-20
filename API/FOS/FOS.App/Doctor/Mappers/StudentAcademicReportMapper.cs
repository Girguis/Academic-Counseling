using AutoMapper;
using FOS.App.Doctors.DTOs;
    
namespace FOS.App.Doctors.Mappers
{
    public static class StudentAcademicReportMapper
    {
        /// <summary>
        /// Extension method used to map from Student, AcademicYearDTO and programName
        /// to StudentAcademicReportDTO model
        /// </summary>
        public static StudentAcademicReportDTO ToDTO(this DB.Models.Student student, List<AcademicYearDTO> academicYears)
        {
            var config = new MapperConfiguration(c =>
            c.CreateMap<DB.Models.Student, StudentAcademicReportDTO>()
            .ForMember(o => o.Cgpa, x => x.MapFrom(z => z.Cgpa))
            .ForMember(o=>o.ProgramName,x=>x.MapFrom(z=>z.CurrentProgram.Name))
            .ForMember(o=>o.SupervisorName,x=>x.MapFrom(z=>z.Supervisor.Name)
            )
            );
            var mapper = config.CreateMapper();
            var studentReport = mapper.Map<StudentAcademicReportDTO>(student);
            studentReport.academicYearsDetails = academicYears;
            studentReport.Rank = student.IsGraduated.Value ? student.Rank : student.CalculatedRank;
            return studentReport;
        }
    }
}
