using Microsoft.Extensions.Configuration;
using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Models
{
    public class AppSettingsModel
    {
        public AppSettingsModel()
        {

        }
        public AppSettingsModel(IConfiguration configuration)
        {
            SummerAllowedHours = GetValueFromAppSetting(configuration, "Summer:HoursToRegister");
            ToNextLevelSkipHours = GetValueFromAppSetting(configuration, "HoursToSkip");
            CourseRegistrationAllowedLevels = GetValueFromAppSetting(configuration, "LevelsRangeForCourseRegistraion");
            CourseOpeningForGraduationAllowedHours = GetValueFromAppSetting(configuration, "HoursForCourseOpeningForGraduation");
            UtcOffset = GetValueFromAppSetting(configuration, "UtcOffset");
        }
        private static int GetValueFromAppSetting(IConfiguration configuration, string key)
        {
            bool parsed = int.TryParse(configuration[key], out int value);
            if (!parsed) value = 0;
            return value;
        }
        [Range(0, int.MaxValue)]
        public int? SummerAllowedHours { get; set; }
        [Range(0, int.MaxValue)]
        public int? ToNextLevelSkipHours { get; set; }
        [Range(0, int.MaxValue)]
        public int? CourseRegistrationAllowedLevels { get; set; }
        [Range(0, int.MaxValue)]
        public int? CourseOpeningForGraduationAllowedHours { get; set; }
        [Range(0, int.MaxValue)]
        public int? UtcOffset { get; set; }
    }

}
