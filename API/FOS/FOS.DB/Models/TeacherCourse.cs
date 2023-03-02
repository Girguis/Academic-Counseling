using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class TeacherCourse
    {
        public int? DoctorId { get; set; }
        public int CourseId { get; set; }
        public short AcademicYearId { get; set; }

        public virtual AcademicYear AcademicYear { get; set; } = null!;
        public virtual Course Course { get; set; } = null!;
        public virtual Doctor? Doctor { get; set; }
    }
}
