using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum DoctorTypesEnum
    {
        [Description("مسئول برنامج")]
        ProgramAdmin = 1,
        [Description("مرشد أكاديمي")]
        Supervisor = 2,
        [Description("دكتور")]
        Doctor = 3
    }
}
