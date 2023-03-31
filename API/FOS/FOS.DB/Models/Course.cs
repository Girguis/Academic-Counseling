using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class Course
    {
        public int Id { get; set; }
        public string CourseCode { get; set; } = null!;
        public string CourseName { get; set; } = null!;
        public byte CreditHours { get; set; }
        public byte LectureHours { get; set; }
        public byte LabHours { get; set; }
        public byte SectionHours { get; set; }
        public bool IsActive { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public int Final { get; set; }
        public int YearWork { get; set; }
        public int Oral { get; set; }
        public int Practical { get; set; }
    }
}
