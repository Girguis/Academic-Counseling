using AutoMapper;
using FOS.Core.Enums;
using FOS.Core.Models.DTOs;

namespace FOS.App.Doctors.Mappers
{
    public static class StudentMapper
    {
        /// <summary>
        /// Extension method used to map from Student model
        /// to StudentWarningsDTO model
        /// </summary>
        public static StudentsDTO ToDTO(this DB.Models.Student student)
        {
            var config = new MapperConfiguration(c => c.CreateMap<DB.Models.Student, StudentsDTO>()
            .ForMember(x => x.ProgramID, o => o.MapFrom(z => z.CurrentProgramId))
            .ForMember(x => x.ProgramName, o => o.MapFrom(z => z.CurrentProgram.ArabicName))
            .ForMember(x => x.SupervisorID, o => o.MapFrom(z => z.SupervisorId))
            .ForMember(x => x.SupervisorName, o => o.MapFrom(z => z.Supervisor.Name))
            );
            var mapper = config.CreateMapper();
            var studentDto = mapper.Map<StudentsDTO>(student);
            try { studentDto.Gender = Enum.GetName(typeof(GenderEnum), Int32.Parse(studentDto.Gender)); }
            catch { studentDto.Gender = Enum.GetName<GenderEnum>(GenderEnum.Male); }
            return studentDto;
        }
    }
}
