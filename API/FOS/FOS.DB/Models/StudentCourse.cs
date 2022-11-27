﻿using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class StudentCourse
    {
        public int StudentId { get; set; }
        public int CourseId { get; set; }
        public byte? Mark { get; set; }
        public string? Grade { get; set; }
        public double? Points { get; set; }
        public bool IsAprroved { get; set; }
        public bool IsGpaincluded { get; set; }
        public bool IsIncluded { get; set; }
        public byte CourseEntringNumber { get; set; }
        public bool AffectReEntringCourses { get; set; }
        public short AcademicYearId { get; set; }

        public virtual AcademicYear AcademicYear { get; set; } = null!;
        public virtual Course Course { get; set; } = null!;
        public virtual Student Student { get; set; } = null!;
    }
}
