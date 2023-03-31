using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum CourseTypeEnum
    {
        [Description("اجبارى")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Mandetory))]
        Mandetory = 1,
        [Description("اختيارى")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Elective))]
        Elective = 2,
        [Description("متطلب جامعة")]
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.UniversityRequirement))]
        UniversityRequirement = 3
    }
}
