using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum DateForEnum
    {
        [Description("التشعيب")]
        Bifurcation,
        [Description("تسجيل المقررات")]
        CourseRegistration,
        [Description("انسحاب من مقرر")]
        CourseWithdraw,
        [Description("حذف واضافة المقرارات")]
        AddAndDeleteCourse
    }
}
