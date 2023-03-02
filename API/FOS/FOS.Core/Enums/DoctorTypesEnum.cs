using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum DoctorTypesEnum
    {
        [Description("Program Admin")]
        ProgramAdmin = 1,
        [Description("Supervisor")]
        Supervisor = 2,
        [Description("Doctor")]
        Doctor = 3
    }
}
