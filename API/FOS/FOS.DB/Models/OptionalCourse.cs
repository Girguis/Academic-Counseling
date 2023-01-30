using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class OptionalCourse
    {
        public int ProgramId { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public byte CourseType { get; set; }
        public byte Category { get; set; }
        public byte Hour { get; set; }

        public virtual Program Program { get; set; } = null!;
    }
}
