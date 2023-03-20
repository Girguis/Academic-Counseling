using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum CourseRequestEnum
    {
        [Description("إضافة")]
        CourseAdd = 1,
        [Description("حذف")]
        CourseDelete,
        [Description("انسحاب")]
        Withdraw,
        [Description("زيادة عبء")]
        OverLoad,
        [Description("فتح مقرر فى غير موعده")]
        OpenCourse,
        [Description("تحسين")]
        Enhancement
    }
}
