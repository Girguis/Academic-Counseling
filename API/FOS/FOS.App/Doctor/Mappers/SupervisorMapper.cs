using AutoMapper;
using FOS.App.Doctors.DTOs;

namespace FOS.App.Doctors.Mappers
{
    public static class DoctorMapper
    {
        /// <summary>
        /// Extension method used to map from Doctor model
        /// to DoctorDTO model
        /// </summary>
        public static DoctorDTO ToDTO(this DB.Models.Doctor supervior)
        {
            var config =
                new MapperConfiguration
                (c => c.CreateMap<DB.Models.Doctor, DoctorDTO>()
                .ForMember(x => x.ProgramName, o => o.MapFrom(y => y.Program.Name))
                );
            var mapper = config.CreateMapper();
            var suppervisorDto = mapper.Map<DoctorDTO>(supervior);
            return suppervisorDto;
        }
    }
}
