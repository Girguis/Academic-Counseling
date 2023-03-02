using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum CourseTypeEnum
    {
        [Description("Mandetory")]
        Mandetory = 1,
        [Description("Elective")]
        Elective = 2,
        [Description("University Requirement")]
        UniversityRequirement = 3
    }
}
