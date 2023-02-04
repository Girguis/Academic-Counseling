using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class ProgramDistribution
    {
        public int ProgramId { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public byte NumberOfHours { get; set; }

        public virtual Program Program { get; set; } = null!;
    }
}
