using AutoMapper;
using FOS.App.Students.DTOs;
using FOS.DB.Models;

namespace FOS.Students.API.Mapper
{
    public static class StudentDesireMapper
    {
        /// <summary>
        /// This is an extension method for student which maps from DesireProgramsDTO model
        /// to StudentDesire (which will be stored in the database)
        /// </summary>
        /// <param name="student"></param>
        /// <param name="desires"></param>
        /// <returns></returns>
        public static List<StudentDesire> ToModel(this DB.Models.Student student, List<DesireProgramsDTO> desires)
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
    }
}
