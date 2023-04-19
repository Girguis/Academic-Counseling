using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum DateForEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Bifuraction))]
        Bifurcation,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CouresRegistration))]
        CourseRegistration,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseWithdraw))]
        CourseWithdraw,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseAddDelete))]
        AddAndDeleteCourse,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseOverload))]
        Overload,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.GraduationCourse))]
        OpenCourseForGraduation,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseEnhancement))]
        Enhancement,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.ProgramTransfer))]
        ProgramTransfer,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.CourseExcuse))]
        CourseExcuse
    }
}
