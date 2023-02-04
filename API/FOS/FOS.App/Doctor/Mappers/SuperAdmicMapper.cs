﻿using AutoMapper;
using FOS.App.Doctor.DTOs;
using FOS.DB.Models;

namespace FOS.App.Supervisor.Mappers
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
