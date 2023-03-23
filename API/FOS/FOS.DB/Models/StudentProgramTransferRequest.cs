using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class StudentProgramTransferRequest
    {
        public int StudentId { get; set; }
        public int ToProgramId { get; set; }
        public string? ReasonForTransfer { get; set; }
        public bool? IsApproved { get; set; }

        public virtual Student Student { get; set; } = null!;
        public virtual Program ToProgram { get; set; } = null!;
    }
}
