using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class StudentCourseRequest
    {
        public string RequestId { get; set; } = null!;
        public short RequestTypeId { get; set; }
        public int StudentId { get; set; }
        public int CourseId { get; set; }
        public bool? IsApproved { get; set; }
        public bool CourseOperationId { get; set; }

        public virtual Course Course { get; set; } = null!;
        public virtual Student Student { get; set; } = null!;
    }
}
