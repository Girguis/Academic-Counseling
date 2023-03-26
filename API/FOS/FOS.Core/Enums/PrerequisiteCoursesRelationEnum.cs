using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum PrerequisiteCoursesRelationEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.NoPrerequisite))]
        NoPrerequisite,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.OnePrerequisite))]
        OnePrerequisite,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.AndRelationPrerequisites))]
        AndRelationPrerequisites,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.OrRelationPrerequisites))]
        OrRelationPrerequisites,
    }
}
