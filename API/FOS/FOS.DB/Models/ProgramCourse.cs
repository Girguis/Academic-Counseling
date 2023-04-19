using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class ProgramCourse
    {
        public int ProgramId { get; set; }
        public int CourseId { get; set; }
        public byte PrerequisiteRelationId { get; set; }
        public byte CourseType { get; set; }
        public byte Category { get; set; }
        public short? DeletionYearId { get; set; }
        public short AddtionYearId { get; set; }

        public virtual AcademicYear AddtionYear { get; set; } = null!;
        public virtual Course Course { get; set; } = null!;
        public virtual AcademicYear? DeletionYear { get; set; }
        public virtual Program Program { get; set; } = null!;
    }
}
