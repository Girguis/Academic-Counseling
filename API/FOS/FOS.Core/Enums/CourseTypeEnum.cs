using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum CourseTypeEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Mandetory))]
        Mandetory = 1,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Elective))]
        Elective = 2,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.UniversityRequirement))]
        UniversityRequirement = 3
    }
}
