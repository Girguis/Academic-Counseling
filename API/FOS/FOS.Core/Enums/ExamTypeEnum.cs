using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum ExamTypeEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Practical))]
        Practical = 1,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Oral))]
        Oral = 2,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.YearWork))]
        YearWork = 3
    }
}
