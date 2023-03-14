using AutoMapper;
using FOS.Core.Models.ParametersModels;
using FOS.DB.Models;

namespace FOS.App.Doctor.Mappers
{
    public static class ProgramMapper
    {
        public static ProgramBasicDataDTO ToProgramBasicDTO(this Program program)
        {
            var config = new MapperConfiguration(c =>
            c.CreateMap<Program, ProgramBasicDataDTO>()
            .ForMember(m => m.SuperProgramName, o => o.MapFrom(t => t.SuperProgram.Name)));
            var mapper = config.CreateMapper();
            return mapper.Map<ProgramBasicDataDTO>(program);
        }
        public static List<ProgramBasicDataDTO> ToProgramBasicDTO(this List<Program> programs)
        {
            var res = new List<ProgramBasicDataDTO>();
            for(int i=0;i<programs.Count;i++)
                res.Add(programs[i].ToProgramBasicDTO());
            return res;
        }
    }
}
