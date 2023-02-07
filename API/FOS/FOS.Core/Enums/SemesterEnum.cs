using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum SemesterEnum
    {
        [Display(Name ="Autumn")]
        Autumn = 1,
        [Display(Name = "Spring")]
        Spring = 2,
        [Display(Name = "Summer")]
        Summer = 3
    }
}
