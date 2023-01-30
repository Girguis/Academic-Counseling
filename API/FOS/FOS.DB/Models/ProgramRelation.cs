using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class ProgramRelation
    {
        public int? Program { get; set; }
        public int SubProgram { get; set; }

        public virtual Program? ProgramNavigation { get; set; }
        public virtual Program SubProgramNavigation { get; set; } = null!;
    }
}
