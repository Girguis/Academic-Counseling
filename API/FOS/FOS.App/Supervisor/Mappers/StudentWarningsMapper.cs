using AutoMapper;
using FOS.App.Supervisor.DTOs;

namespace FOS.App.Supervisor.Mappers
{
    public static class StudentWarningsMapper
    {
        public static StudentWarningsDTO ToDTO(this DB.Models.Student student)
        {
            var config = new MapperConfiguration(c => c.CreateMap<DB.Models.Student, StudentWarningsDTO>());
            var mapper = config.CreateMapper();
            var studentDto = mapper.Map<StudentWarningsDTO>(student);
            return studentDto;
        }
    }
}
