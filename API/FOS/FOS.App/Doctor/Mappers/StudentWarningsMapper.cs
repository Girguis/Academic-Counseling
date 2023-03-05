﻿using AutoMapper;
using FOS.App.Doctors.DTOs;

namespace FOS.App.Doctors.Mappers
{
    public static class StudentWarningsMapper
    {
        /// <summary>
        /// Extension method used to map from Student model
        /// to StudentWarningsDTO model
        /// </summary>
        public static StudentsDTO ToDTO(this DB.Models.Student student)
        {
            var config = new MapperConfiguration(c => c.CreateMap<DB.Models.Student, StudentsDTO>()
            .ForMember(x=>x.ProgramID,o=>o.MapFrom(z=>z.CurrentProgramId))
            .ForMember(x=>x.ProgramName,o=>o.MapFrom(z=>z.CurrentProgram.ArabicName))
            );
            var mapper = config.CreateMapper();
            var studentDto = mapper.Map<StudentsDTO>(student);
            return studentDto;
        }
    }
}
