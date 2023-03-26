using AutoMapper;
using FOS.App.Doctors.DTOs;
using FOS.Core.Enums;
using FOS.DB.Models;
using System.ComponentModel.DataAnnotations;

namespace FOS.App.Doctors.Mappers
{
    public static class DateMapper
    {
        public static DateDTO ToDTO(this Date date)
        {
            var config = new MapperConfiguration(x =>
                x.CreateMap<Date, DateDTO>()
                .ForMember(x => x.DateForID, o => o.MapFrom(z => z.DateFor))
                .ForMember(x => x.DateFor, o => o.MapFrom(z => Helpers.Helper.GetDisplayName((DateForEnum)z.DateFor)))
            );
            var mapper = config.CreateMapper();
            var dateDto = mapper.Map<DateDTO>(date);
            return dateDto;
        }
    }
}
