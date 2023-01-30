using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class ProgramCourse
    {
        public int ProgramId { get; set; }
        public int CourseId { get; set; }
        public byte CourseType { get; set; }
        public byte Category { get; set; }

        public virtual Course Course { get; set; } = null!;
        public virtual Program Program { get; set; } = null!;
    }
}
