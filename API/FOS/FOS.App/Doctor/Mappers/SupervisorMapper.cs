using AutoMapper;
using FOS.App.Doctor.DTOs;

namespace FOS.App.Supervisor.Mappers
{
    public static class SupervisorMapper
    {
        /// <summary>
        /// Extension method used to map from Supervisor model
        /// to SupervisorDTO model
        /// </summary>
        public static SupervisorDTO ToDTO(this DB.Models.Supervisor supervior)
        {
            var config =
                new MapperConfiguration
                (c => c.CreateMap<DB.Models.Supervisor, SupervisorDTO>()
                .ForMember(x => x.ProgramName, o => o.MapFrom(y => y.Program.Name))
                );
            var mapper = config.CreateMapper();
            var suppervisorDto = mapper.Map<SupervisorDTO>(supervior);
            return suppervisorDto;
        }
    }
}
