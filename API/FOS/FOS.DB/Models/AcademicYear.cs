using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class AcademicYear
    {
        public AcademicYear()
        {
            StudentEnrollYears = new HashSet<Student>();
            StudentGraduatedYears = new HashSet<Student>();
        }

        public short Id { get; set; }
        public string AcademicYear1 { get; set; } = null!;
        public byte Semester { get; set; }

        public virtual ICollection<Student> StudentEnrollYears { get; set; }
        public virtual ICollection<Student> StudentGraduatedYears { get; set; }
    }
}
