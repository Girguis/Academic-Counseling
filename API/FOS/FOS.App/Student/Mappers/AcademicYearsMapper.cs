﻿using AutoMapper;
using FOS.App.Student.DTOs;
using FOS.DB.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FOS.App.Student.Mappers
{
    public static class AcademicYearsMapper
    {
        public static AcademicYearsDTO ToDTO(this AcademicYear academicYear, double? sGpa)
        {
            try
            {
                var config = new MapperConfiguration(c =>
                           c.CreateMap<AcademicYear, AcademicYearsDTO>()
                           .ForMember(m => m.ID, o => o.MapFrom(t => t.Id))
                           .ForMember(m => m.AcademicYear, o => o.MapFrom(t => t.AcademicYear1))
                           .ForMember(m => m.Semester, o => o.MapFrom(t => t.Semester))
                           );
                var mapper = config.CreateMapper();
                var academicYearsDTO = mapper.Map<AcademicYearsDTO>(academicYear);
                academicYearsDTO.SGPA = sGpa.Value;
                return academicYearsDTO;
            }
            catch (Exception ex)
            {

            }
            return null;
        }
    }
}
