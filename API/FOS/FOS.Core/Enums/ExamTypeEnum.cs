using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum ExamTypeEnum
    {
        [Description("امتحان نهائى")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Final))]
        Final = 1,
        [Description("أعمال فصلية")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.YearWork))]
        YearWork = 2,
        [Description("شفوي")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Oral))]
        Oral = 3,
        [Description("عملي")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Practical))]
        Practical = 4
    }
}
