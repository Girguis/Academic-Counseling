using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum CourseTypeEnum
    {
        [Description("اجبارى")]
        Mandetory = 1,
        [Description("اختياري")]
        Elective = 2,
        [Description("متطلب جامعة")]
        UniversityRequirement = 3
    }
}
