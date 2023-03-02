using AutoMapper;
using FOS.App.Doctors.DTOs;
using FOS.DB.Models;

namespace FOS.App.Doctors.Mappers
{
    public static class SuperAdminMapper
    {
        /// <summary>
        /// Extension method used to map from SuperAdmin model
        /// to SuperAdminDTO model
        /// </summary>
        public static SuperAdminDTO ToDTO(this SuperAdmin superAdmin)
        {
            var config =
                new MapperConfiguration
                (c => c.CreateMap<SuperAdmin, SuperAdminDTO>());
            var mapper = config.CreateMapper();
            var superAdminDto = mapper.Map<SuperAdminDTO>(superAdmin);
            return superAdminDto;
        }
    }
}
