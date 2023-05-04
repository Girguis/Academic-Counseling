using FOS.App.Students.Mappers;
using FOS.Core.Configs;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.DB.Models;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Dynamic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace FOS.App.Helpers
{
    public static class Helper
    {
        public static int GetUtcOffset()
        {
            return ConfigurationsManager.TryGetNumber(Config.UtcOffset, 2);
        }
        public static void UpdateAppSettings(AppSettingsModel model)
        {
            var appSettingsPath = Path.Combine(Directory.GetCurrentDirectory(), "appsettings.json");
            var json = File.ReadAllText(appSettingsPath);

            var jsonSettings = new JsonSerializerSettings();
            jsonSettings.Converters.Add(new ExpandoObjectConverter());
            jsonSettings.Converters.Add(new StringEnumConverter());

            dynamic config = JsonConvert.DeserializeObject<ExpandoObject>(json, jsonSettings);
            if (model.ToNextLevelSkipHours.HasValue)
                config.HoursToSkip = model.ToNextLevelSkipHours.Value;
            if (model.SummerAllowedHours.HasValue)
                config.Summer.HoursToRegister = model.SummerAllowedHours.Value;
            if (model.CourseRegistrationAllowedLevels.HasValue)
                config.LevelsRangeForCourseRegistraion = model.CourseRegistrationAllowedLevels.Value;
            if (model.CourseOpeningForGraduationAllowedHours.HasValue)
                config.HoursForCourseOpeningForGraduation = model.CourseOpeningForGraduationAllowedHours.Value;
            if(model.UtcOffset.HasValue)
                config.UtcOffset = model.UtcOffset.Value;
            var newJson = JsonConvert.SerializeObject(config, Formatting.Indented, jsonSettings);

            File.WriteAllText(appSettingsPath, newJson);
        }
        public static bool IsValidCourseData(AddCourseParamModel course)
        {
            int totalMarks = course.Practical + course.Final + course.Oral + course.YearWork;
            if (course.CreditHours == 0)
                return totalMarks % 50 == 0;
            if (course.LectureHours + ((course.LabHours + course.SectionHours) / 2) != course.CreditHours)
                return false;
            return course.CreditHours * 50 == totalMarks;
        }
        public static bool HasThisTypeOfExam(int examType, Course course)
        {
            return (examType == (int)ExamTypeEnum.Final && course.Final != 0)
                    || (examType == (int)ExamTypeEnum.YearWork && course.YearWork != 0)
                    || (examType == (int)ExamTypeEnum.Oral && course.Oral != 0)
                    || (examType == (int)ExamTypeEnum.Practical && course.Practical != 0);
        }
        public static bool HasFinalExam(this Course course)
        {
            return course.Final != 0;
        }
        public static bool HasYearWorkExams(this Course course)
        {
            return course.YearWork != 0 || course.Oral != 0 || course.Practical != 0;
        }
        public static bool HasThisTypeOfExam(int examType, CourseOutModel course)
        {
            return (examType == (int)ExamTypeEnum.Final && course.Final != 0)
                    || (examType == (int)ExamTypeEnum.YearWork && course.YearWork != 0)
                    || (examType == (int)ExamTypeEnum.Oral && course.Oral != 0)
                    || (examType == (int)ExamTypeEnum.Practical && course.Practical != 0);
        }
        public static byte GetSemesterNumber(string semesterStr)
        {
            if (semesterStr.Contains("الخريف"))
                return (byte)SemesterEnum.Fall;
            else if (semesterStr.Contains("الربيع"))
                return (byte)SemesterEnum.Spring;
            else
                return (byte)SemesterEnum.Summer;
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
                list.Add(new General { ID = (int)value, Name = GetDisplayName((TEnum)value) });
            }
            return list;
        }
        public static string GetDisplayName(Enum value)
        {
            return GetEnumAttributes<DisplayAttribute>(value).GetName();
        }
        public static string GetDescription(Enum value)
        {
            return GetEnumAttributes<DescriptionAttribute>(value).Description;
        }
        public static TAttribute GetEnumAttributes<TAttribute>(Enum value)
            where TAttribute : Attribute
        {
            return value.GetType()
                       .GetMember(value.ToString())
                       .First()
                       .GetCustomAttribute<TAttribute>();
            //    FieldInfo fi = value.GetType().GetField(value.ToString());
            //    DescriptionAttribute[] attributes = fi.GetCustomAttributes(typeof(DescriptionAttribute), false) as DescriptionAttribute[];
            //    if (attributes != null && attributes.Any())
            //        return attributes.First().Description;
            //    return value.ToString();
            //}
        }
        public static List<General> ProgramsToList(List<ProgramBasicDataDTO> programs)
        {
            return programs.Select(x => new General
            {
                ID = x.Guid,
                Name = x.Name
            }).ToList();
        }
        public static List<General> CoursesToList(List<Course> courses)
        {
            return courses.Select(x => new General
            {
                ID = x.Guid,
                Name = string.Concat(x.CourseCode, "-", x.CourseName)
            }).ToList();
        }
        public static List<General> AcademicYearsToList(List<AcademicYear> academicYears)
        {
            return academicYears.Select(x => new General
            {
                ID = x.Id,
                Name = string.Concat(x.AcademicYear1, " - ", GetDisplayName((SemesterEnum)x.Semester))
            })?.ToList();
        }
        public static int GetAllowedHoursToRegister(IAcademicYearRepo academicYearRepo, IConfiguration configuration, Student student, IProgramDistributionRepo programDistributionRepo)
        {
            int allowedHoursToRegister;
            int currentSemester = academicYearRepo.GetCurrentYear().Semester;
            if (currentSemester == 3)
            {
                allowedHoursToRegister = ConfigurationsManager
                    .TryGetNumber(Config.SummerRegHours, 6);
            }
            else
            {
                if (!student.Cgpa.HasValue || student.Cgpa.Value >= 2)
                    allowedHoursToRegister = programDistributionRepo.GetAllowedHoursToRegister(student.CurrentProgramId.HasValue ? student.CurrentProgramId.Value : 1, student.Level.Value, student.PassedHours.Value, currentSemester) ?? 0;
                else
                    allowedHoursToRegister = 12;
            }
            return allowedHoursToRegister;
        }
        public static List<ElectiveCoursesDistribtionOutModel> GetElectiveCoursesDistribution(IElectiveCourseDistributionRepo optionalCourseRepo, IEnumerable<byte> levels, IEnumerable<byte> semesters, int studentID)
        {
            List<ElectiveCourseDistribution> optionalCoursesDistribution = optionalCourseRepo
                                                    .GetOptionalCoursesDistibution(studentID)
                                                    ?.Where(x => levels.Any(z => z == x.Level) && semesters.Any(z => z == x.Semester))
                                                    ?.ToList();
            List<ElectiveCoursesDistribtionOutModel> optionalCoursesDTO = new();
            for (int i = 0; i < optionalCoursesDistribution.Count; i++)
                optionalCoursesDTO.Add(optionalCoursesDistribution.ElementAt(i).ToDTO());
            return optionalCoursesDTO;
        }
    }
}
