using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum SemesterEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Fall))]
        Fall = 1,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Spring))]
        Spring = 2,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Summer))]
        Summer = 3
    }
}
