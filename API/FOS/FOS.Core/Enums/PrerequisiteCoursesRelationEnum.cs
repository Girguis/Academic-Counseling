using System.ComponentModel;

namespace FOS.Core.Enums
{
    public enum PrerequisiteCoursesRelationEnum
    {
        [Description("Has No Prerequisites")]
        NoPrerequisite,
        [Description("Has 1 Prerequisite")]
        OnePrerequisite,
        [Description("Prerequisites with 'AND' relation")]
        AndRelationPrerequisites,
        [Description("Prerequisites with 'OR' relation")]
        OrRelationPrerequisites,
    }
}
