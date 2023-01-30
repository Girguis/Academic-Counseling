using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class TeacherCourse
    {
        public int? SupervisorId { get; set; }
        public int CourseId { get; set; }
        public short AcademicYearId { get; set; }

        public virtual AcademicYear AcademicYear { get; set; } = null!;
        public virtual Course Course { get; set; } = null!;
        public virtual Supervisor? Supervisor { get; set; }
    }
}
