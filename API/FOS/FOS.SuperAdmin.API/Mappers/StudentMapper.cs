using AutoMapper;
using FOS.DB.Models;
using FOS.Doctor.API.Models;

namespace FOS.Doctor.API.Mappers
{
    public static class StudentMapper
    {
        public static Student ToDbModel(this StudentBasicModel basicModel)
        {
            var config = new MapperConfiguration(x => x.CreateMap<StudentBasicModel, Student>());
            var mapper = config.CreateMapper();
            var student = mapper.Map<Student>(basicModel);
            student.Address = "العنوان";
            student.CreatedOn = DateTime.UtcNow.AddHours(2);
            student.Email = student.Ssn + "@sci.asu.edu.eg";
            student.Password = "0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C";
            if(student.Ssn.Length == 14)
            {
                student.Gender = int.Parse(student.Ssn[student.Ssn.Length - 2].ToString()) % 2 == 0 ? "2" : "1";
                string yearFP = student.Ssn[0] == 2 ? "19" : "20";
                string date = string.Concat(yearFP, student.Ssn[1], student.Ssn[2], "/", student.Ssn[3], student.Ssn[4], "/", student.Ssn[5], student.Ssn[6]);
                student.BirthDate = DateTime.Parse(date);
            }
            else
            {
                student.Gender = "1";
                student.BirthDate = DateTime.UtcNow.AddHours(2);
            }
            student.Guid = Guid.NewGuid().ToString();
            student.PhoneNumber = "12345678912";
            student.Nationality = "مصرى";
            return student;
        }
    }
}
