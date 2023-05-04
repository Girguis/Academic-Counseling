using AutoMapper;
using FOS.App.Helpers;
using FOS.DB.Models;
using FOS.Doctors.API.Models;

namespace FOS.Doctors.API.Mappers
{
    public static class StudentMapper
    {
        public static Student ToDbModel(this StudentBasicModel basicModel)
        {
            var config = new MapperConfiguration(x => x.CreateMap<StudentBasicModel, Student>());
            var mapper = config.CreateMapper();
            var student = mapper.Map<Student>(basicModel);
            student.Address = "العنوان";
            student.AcademicCode = basicModel.SeatNumber;
            student.CreatedOn = DateTime.UtcNow.AddHours(Helper.GetUtcOffset());
            student.Email = student.Ssn + "@sci.asu.edu.eg";
            student.Password = Helper.HashPassowrd("Sci@2023");
            if(student.Ssn.Length == 14)
            {
                student.Gender = int.Parse(student.Ssn[student.Ssn.Length - 2].ToString()) % 2 == 0 ? "2" : "1";
                string yearFP = student.Ssn[0] == 2 ? "19" : "20";
                string date = string.Concat(yearFP, student.Ssn[1], student.Ssn[2], "/", student.Ssn[3], student.Ssn[4], "/", student.Ssn[5], student.Ssn[6]);
                bool parsed = DateTime.TryParse(date, out DateTime birthDate);
                if(!parsed) birthDate = DateTime.UtcNow;
                student.BirthDate = birthDate;
            }
            else
            {
                student.Gender = "1";
                student.BirthDate = DateTime.UtcNow;
            }
            student.Guid = Guid.NewGuid().ToString();
            student.PhoneNumber = "12345678912";
            student.Nationality = "مصرى";
            student.SemestersNumberInProgram = basicModel.NumberOfSemesters;
            return student;
        }
    }
}
