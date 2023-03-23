namespace FOS.Core.Models.StoredProcedureOutputModels
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class StudentCoursesOutModel
    {
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public int CreditHours { get; set; }
        public byte? Mark { get; set; }
        public string? Grade { get; set; }
        public double? Points { get; set; }
        public bool IsApproved { get; set; }
        public bool IsGpaIncluded { get; set; }
        public bool IsIncluded { get; set; }
        public byte? CourseEntringNumber { get; set; }
        public short AcademicYearId { get; set; }
        public bool? HasExecuse { get; set; }
        public bool? WillTakeFullCredit { get; set; }
        public bool? TookFromCredits { get; set; }
        public bool? IsEnhancementCourse { get; set; }
    }
}
