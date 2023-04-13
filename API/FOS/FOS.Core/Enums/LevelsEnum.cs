using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum LevelsEnum
    {
        [Description("المستوى الأول")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.First))]
        First = 1,
        [Description("المستوى الثانى")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Second))]
        Second = 2,
        [Description("المستوى الثالث")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Third))]
        Third = 3,
        [Description("المستوى الرابع")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Fourth))]
        Fourth = 4

    }
}
