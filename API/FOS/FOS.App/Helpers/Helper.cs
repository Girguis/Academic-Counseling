using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Vml;
using DocumentFormat.OpenXml.Wordprocessing;
using FOS.Core.Enums;
using FOS.DB.Models;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.OpenApi.Extensions;
using System;
using System.Collections.Immutable;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
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
            foreach(var value in values)
            {
                list.Add(new General { ID = (int)value, Name = GetEnumDescription(value) });
            }
            return list;
        }
        private static string GetEnumDescription(object value)
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
    }

    public class General
    {
        public int ID { get; set; }
        public string Name { get; set; }
    }
}
