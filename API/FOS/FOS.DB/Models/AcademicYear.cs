using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class AcademicYear
    {
        public short Id { get; set; }
        public string AcademicYear1 { get; set; } = null!;
        public byte Semester { get; set; }
    }
}
