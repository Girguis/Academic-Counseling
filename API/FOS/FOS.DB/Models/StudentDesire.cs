using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class StudentDesire
    {
        public int ProgramId { get; set; }
        public int StudentId { get; set; }
        public byte DesireNumber { get; set; }
        public int? StudentCurrentProgramId { get; set; }

        public virtual Program Program { get; set; } = null!;
        public virtual Student Student { get; set; } = null!;
    }
}
