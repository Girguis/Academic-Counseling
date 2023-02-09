using AutoMapper;
using FOS.App.Doctor.DTOs;
using FOS.Core.Enums;
using FOS.DB.Models;

namespace FOS.App.Doctor.Mappers
{
    public static class DateMapper
    {
        public static DateDTO ToDTO(this Date date)
        {
            var config = new MapperConfiguration(x =>
                x.CreateMap<Date, DateDTO>()
                .ForMember(x => x.DateForID, o => o.MapFrom(z => z.DateFor))
                .ForMember(x => x.DateFor, o => o.MapFrom(z => Enum.GetName((DateForEnum)z.DateFor)))
            );
            var mapper = config.CreateMapper();
            var dateDto = mapper.Map<DateDTO>(date);
            return dateDto;
        }
    }
}
