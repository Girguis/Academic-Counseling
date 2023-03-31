using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum SemesterEnum
    {
        [Description("فصل الخريف")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Fall))]
        Fall = 1,
        [Description("فصل الربيع")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Spring))]
        Spring = 2,
        [Description("فصل الصيف")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Summer))]
        Summer = 3
    }
}
