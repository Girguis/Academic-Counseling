using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum CourseRequestEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseAddDelete))]
        AddtionDeletion = 1,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseWithdraw))]
        Withdraw,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseOverload))]
        OverLoad,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.GraduationCourse))]
        OpenCourse,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseEnhancement))]
        Enhancement,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseExcuse))]
        Excuse
    }
    public enum CourseOperationEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Delete))]
        Deletion,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Add))]
        Addtion
    }
}
