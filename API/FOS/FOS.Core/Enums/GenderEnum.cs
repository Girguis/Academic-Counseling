using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum GenderEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Male))]
        Male = 1,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Female))]
        Female = 2
    }
}
