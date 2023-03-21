using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum SemesterEnum
    {
        [Description("فصل الخريف")]
        Fall = 1,
        [Description("فصل الربيع")]
        Spring = 2,
        [Description("فصل الصيف")]
        Summer = 3
    }
}
