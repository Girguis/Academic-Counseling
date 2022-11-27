using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class StudentProgram
    {
        public int ProgramId { get; set; }
        public int StudentId { get; set; }
        public short AcademicYear { get; set; }

        public virtual AcademicYear AcademicYearNavigation { get; set; } = null!;
        public virtual Program Program { get; set; } = null!;
        public virtual Student Student { get; set; } = null!;
    }
}
