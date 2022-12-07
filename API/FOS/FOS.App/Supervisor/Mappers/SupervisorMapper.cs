using AutoMapper;
using FOS.App.Supervisor.DTOs;

namespace FOS.App.Supervisor.Mappers
{
    public static class SupervisorMapper
    {
        public static SupervisorDTO ToDTO(this DB.Models.Supervisor supervior)
        {
            try
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
            catch (Exception ex)
            {

            }
            return null;
        }
    }
}
