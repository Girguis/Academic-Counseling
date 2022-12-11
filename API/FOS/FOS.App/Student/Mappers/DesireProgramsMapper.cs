using AutoMapper;
using FOS.App.Student.DTOs;
using FOS.DB.Models;

namespace FOS.App.Student.Mappers
{
    public static class DesireProgramsMapper
    {
        public static List<DesireProgramsDTO> ToDTO(this List<Program> programs)
        {
            var config = new MapperConfiguration(c => c.CreateMap<DB.Models.Program, DesireProgramsDTO>()
            .ForMember(x => x.ProgramID, o => o.MapFrom(y => y.Id))
            .ForMember(x => x.ProgramName, o => o.MapFrom(y => y.ArabicName))
            );
            var mapper = config.CreateMapper();
            List<DesireProgramsDTO> desireProgramsDTOs = new List<DesireProgramsDTO>();
            for (int i = 0; i < programs.Count; i++)
            {
                desireProgramsDTOs.Add(mapper.Map<DesireProgramsDTO>(programs.ElementAt(i)));
                desireProgramsDTOs.ElementAt(i).DesireNumber = i + 1;
            }
            return desireProgramsDTOs;
        }

        public static List<DesireProgramsDTO> ToDTO(this List<StudentDesire> desires)
        {
            var config = new MapperConfiguration(c => c.CreateMap<DB.Models.StudentDesire, DesireProgramsDTO>()
            .ForMember(x => x.ProgramID, o => o.MapFrom(y => y.ProgramId))
            .ForMember(x => x.ProgramName, o => o.MapFrom(y => y.Program.ArabicName))
            .ForMember(x => x.DesireNumber, o => o.MapFrom(y => y.DesireNumber))
            );
            var mapper = config.CreateMapper();
            List<DesireProgramsDTO> desireProgramsDTOs = new List<DesireProgramsDTO>();
            for (int i = 0; i < desires.Count; i++)
                desireProgramsDTOs.Add(mapper.Map<DesireProgramsDTO>(desires.ElementAt(i)));

            return desireProgramsDTOs;
        }
    }
}
