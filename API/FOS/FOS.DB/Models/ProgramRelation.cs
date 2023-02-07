using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class ProgramRelation
    {
        public int? ProgramId { get; set; }
        public int SubProgramId { get; set; }

        public virtual Program? Program { get; set; }
        public virtual Program SubProgram { get; set; } = null!;
    }
}
