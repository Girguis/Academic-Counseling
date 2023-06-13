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
        public int Final { get; set; }
        public int YearWork { get; set; }
        public int Oral { get; set; }
        public int Practical { get; set; }
        public byte? Mark { get; set; }
        public string? Grade { get; set; }
        public double? Points { get; set; }
        public bool IsApproved { get; set; }
        public bool IsGpaIncluded { get; set; }
        public bool IsIncluded { get; set; }
        public byte? CourseEntringNumber { get; set; }
        public short AcademicYearId { get; set; }
        public bool? HasExcuse { get; set; }
        public bool HasWithdrawn { get; set; }
        public bool? WillTakeFullCredit { get; set; }
        public bool? TookFromCredits { get; set; }
        public bool? IsEnhancementCourse { get; set; }
        public int? SFinal { get; set; }
        public int? SYearWork { get; set; }
        public int? SOral { get; set; }
        public int? SPractical { get; set; }

    }
}
