using DocumentFormat.OpenXml;
using FOS.App.Repositories;
using FOS.App.Students.DTOs;
using FOS.App.Students.Mappers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Extensions.Configuration;
using System.ComponentModel;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace FOS.App.Helpers
{
    public static class Helper
    {
        public static byte GetSemesterNumber(string semesterStr)
        {
            if (semesterStr.Contains("الخريف"))
                return (byte)SemesterEnum.Fall;
            else if (semesterStr.Contains("الربيع"))
                return (byte)SemesterEnum.Spring;
            else
                return (byte)SemesterEnum.Summer;
        }
        public static string GetSemesterName(int semesterNumber)
        {
            if ((byte)SemesterEnum.Fall == semesterNumber)
                return Enum.GetName(SemesterEnum.Fall);
            else if ((byte)SemesterEnum.Spring == semesterNumber)
                return Enum.GetName(SemesterEnum.Spring);
            else
                return Enum.GetName(SemesterEnum.Summer);
        }
        public static string HashPassowrd(string password)
        {
            var sha512 = SHA512.Create();
            var passWithKey = "MSKISH" + password + "20MSKISH22";
            var bytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(passWithKey));
            return BitConverter.ToString(bytes).Replace("-", "");
        }
        public static List<General> EnumToList<TEnum>() where TEnum : Enum
        {
            var values = Enum.GetValues(typeof(TEnum));
            List<General> list = new();
            foreach (var value in values)
            {
                list.Add(new General { ID = (int)value, Name = GetEnumDescription(value) });
            }
            return list;
        }
        public static string GetExamTypeName(int type)
        {
            if ((int)ExamTypeEnum.Practical == type)
                return "عملي ";
            else if ((int)ExamTypeEnum.Oral == type)
                return "شفوي";
            else
                return "أعمال فصلية";
        }
        public static string GetEnumDescription(object value)
        {
            FieldInfo fi = value.GetType().GetField(value.ToString());
            DescriptionAttribute[] attributes = fi.GetCustomAttributes(typeof(DescriptionAttribute), false) as DescriptionAttribute[];
            if (attributes != null && attributes.Any())
                return attributes.First().Description;
            return value.ToString();
        }
        public static List<General> ProgramsToList(List<Program> programs)
        {
            return programs.Select(x => new General
            {
                ID = x.Id,
                Name = string.Concat(x.Name)
            }).ToList();
        }
        public static List<General> CoursesToList(List<Course> courses)
        {
            return courses.Select(x => new General
            {
                ID = x.Id,
                Name = string.Concat(x.CourseCode, "-", x.CourseName)
            }).ToList();
        }
        public static List<General> AcademicYearsToList(List<AcademicYear> academicYears)
        {
            return academicYears.Select(x => new General
            {
                ID = x.Id,
                Name = string.Concat(x.AcademicYear1, " - ", GetSemesterName(x.Semester))
            })?.ToList();
        }
        public static int GetAllowedHoursToRegister(IAcademicYearRepo academicYearRepo,IConfiguration configuration,Student student,IProgramDistributionRepo programDistributionRepo)
        {
            int allowedHoursToRegister;
            int currentSemester = academicYearRepo.GetCurrentYear().Semester;
            if (currentSemester == 3)
            {
                bool parsed = int.TryParse(configuration["Summer:HoursToRegister"], out allowedHoursToRegister);
                if (!parsed)
                    allowedHoursToRegister = 6;
            }
            else
            {
                if (!student.Cgpa.HasValue || student.Cgpa.Value >= 2)
                    allowedHoursToRegister = programDistributionRepo.GetAllowedHoursToRegister(student.CurrentProgramId.HasValue ? student.CurrentProgramId.Value : 1, student.Level.Value, student.PassedHours.Value, currentSemester);
                else
                    allowedHoursToRegister = 12;
            }
            return allowedHoursToRegister;
        }
        public static List<ElectiveCoursesDistribtionOutModel> GetElectiveCoursesDistribution(IElectiveCourseDistributionRepo optionalCourseRepo, IEnumerable<byte> levels,IEnumerable<byte> semesters,int studentID)
        {
            List<ElectiveCourseDistribution> optionalCoursesDistribution = optionalCourseRepo
                                                    .GetOptionalCoursesDistibution(studentID)
                                                    .Where(x => levels.Any(z => z == x.Level) && semesters.Any(z => z == x.Semester))
                                                    .ToList();
            List<ElectiveCoursesDistribtionOutModel> optionalCoursesDTO = new();
            for (int i = 0; i < optionalCoursesDistribution.Count; i++)
                optionalCoursesDTO.Add(optionalCoursesDistribution.ElementAt(i).ToDTO());
            return optionalCoursesDTO;
        }
    }

    public class General
    {
        public int ID { get; set; }
        public string Name { get; set; }
    }
}
