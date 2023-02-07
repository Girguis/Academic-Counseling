using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum PrerequisiteCoursesRelationEnum
    {
        [Display(Name ="Has No Prerequisites")]
        NoPrerequisite,
        [Display(Name = "Has 1 Prerequisite")]
        OnePrerequisite,
        [Display(Name = "Prerequisites with \"AND\" relation")]
        AndRelationPrerequisites,
        [Display(Name = "Prerequisites with \"OR\" relation")]
        OrRelationPrerequisites,
    }
}
