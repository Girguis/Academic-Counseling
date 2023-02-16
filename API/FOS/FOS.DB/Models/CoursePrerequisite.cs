using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class CoursePrerequisite
    {
        public int ProgramId { get; set; }
        public int CourseId { get; set; }
        public int PrerequisiteCourseId { get; set; }

        public virtual Course Course { get; set; } = null!;
        public virtual Course PrerequisiteCourse { get; set; } = null!;
        public virtual Program Program { get; set; } = null!;
    }
}
