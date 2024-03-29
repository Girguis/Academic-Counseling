﻿using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class Course
    {
        public int Id { get; set; }
        public string Guid { get; set; } = null!;
        public string CourseCode { get; set; } = null!;
        public string CourseName { get; set; } = null!;
        public byte CreditHours { get; set; }
        public byte LectureHours { get; set; }
        public byte LabHours { get; set; }
        public byte SectionHours { get; set; }
        public bool IsActive { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public byte Final { get; set; }
        public byte YearWork { get; set; }
        public byte Oral { get; set; }
        public byte Practical { get; set; }
    }
}
