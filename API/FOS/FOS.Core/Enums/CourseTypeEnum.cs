using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum CourseTypeEnum
    {
        [Display(Name = "Mandetory")]
        Mandetory = 1,
        [Display(Name = "Elective")]
        Elective = 2,
        [Display(Name = "University Requirement")]
        UniversityRequirement = 3
    }
}
