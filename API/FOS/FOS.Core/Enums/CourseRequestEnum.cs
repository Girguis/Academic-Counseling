using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum CourseRequestEnum
    {
        [Description("حذف وإضافة")]
        AddtionDeletion = 1,
        [Description("انسحاب")]
        Withdraw,
        [Description("زيادة عبء")]
        OverLoad,
        [Description("فتح مقرر فى غير موعده")]
        OpenCourse,
        [Description("تحسين")]
        Enhancement
    }
    public enum CourseOperationEnum
    {
        [Description("حذف")]
        Deletion,
        [Description("إضافة")]
        Addtion
    }
}
