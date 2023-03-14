using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum PrerequisiteCoursesRelationEnum
    {
        [Description("بدون متطلب")]
        NoPrerequisite,
        [Description("متطلب واحد")]
        OnePrerequisite,
        [Description("أكثر من متطلب العلاقة بينهم(و)")]
        AndRelationPrerequisites,
        [Description("أكثر من متطلب العلاقة بينهم(أو)")]
        OrRelationPrerequisites,
    }
}
