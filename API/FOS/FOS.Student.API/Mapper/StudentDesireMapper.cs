using AutoMapper;
using FOS.App.Student.DTOs;
using FOS.DB.Models;

namespace FOS.Student.API.Mapper
{
    public static class StudentDesireMapper
    {
        public static List<StudentDesire> ToModel(this DB.Models.Student student, List<DesireProgramsDTO> desires)
        {
            try
            {
                var config = new MapperConfiguration(x => x.CreateMap<DesireProgramsDTO, StudentDesire>()
                .ForMember(x => x.ProgramId, o => o.MapFrom(z => z.ProgramID))
                .ForMember(x => x.DesireNumber, o => o.MapFrom(z => z.DesireNumber))
                );
                var mapper = config.CreateMapper();
                List<StudentDesire> mappedDesires = new List<StudentDesire>();
                for (int i = 0; i < desires.Count; i++)
                {
                    mappedDesires.Add(mapper.Map<StudentDesire>(desires.ElementAt(i)));
                    mappedDesires.ElementAt(i).StudentId = student.Id;
                }
                return mappedDesires;
            }
            catch (Exception ex)
            {

            }
            return null;
        }
    }
}
