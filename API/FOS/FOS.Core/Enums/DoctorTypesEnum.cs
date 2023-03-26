using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Enums
{
    public enum DoctorTypesEnum
    {
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.ProgramAdmin))]
        ProgramAdmin = 1,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Supervisor))]
        Supervisor = 2,
        [Display(ResourceType = typeof(Languages.Resource), Name = nameof(Languages.Resource.Doctor))]
        Doctor = 3
    }
}
