using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum ExamTypeEnum
    {
        [Description("عملي")]
        Practical = 1,
        [Description("شفوي")]
        Oral = 2,
        [Description("أعمال فصلية")]
        YearWork = 3
    }
}
