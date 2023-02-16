namespace FOS.App.Student.DTOs
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class StudentCoursesDTO
    {
        public string CourceName { get; set; }
        public string CourceCode { get; set; }
        public int CourceCredits { get; set; }
        public byte? Mark { get; set; }
        public string? Grade { get; set; }
        public double? Points { get; set; }
        public bool IsApproved { get; set; }
        public bool IsGpaincluded { get; set; }
        public bool IsIncluded { get; set; }
        public byte? CourseEntringNumber { get; set; }
        public short AcademicYearId { get; set; }
        public bool? HasExecuse { get; set; }
        public bool? WillTakeFullCredit { get; set; }
        public bool? TookFromCredits { get; set; }
        public bool? IsEnhancementCourse { get; set; }
    }
}
