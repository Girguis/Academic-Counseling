using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum DateForEnum
    {
        [Display(Name = "Bifurcation")]
        Bifurcation,
        [Display(Name = "Course Registration")]
        CourseRegistration,
        [Display(Name = "Course Withdraw")]
        CourseWithdraw,
        [Display(Name = "Courses Add And Delete")]
        AddAndDeleteCourse
    }
}
