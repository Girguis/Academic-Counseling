namespace FOS.Core.Models.DTOs
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class StudentAcademicReportDTO
    {
        public string Name { get; set; }
        public string SSN { get; set; }
        public decimal? Cgpa { get; set; }
        public string ProgramName { get; set; }
        public byte? PassedHours { get; set; }
        public byte? Level { get; set; }
        public byte? WarningsNumber { get; set; }
        public string SeatNumber { get; set; }
        public string AcademicCode { get; set; }
        public string SupervisorName { get; set; }
        public byte AvailableCredits { get; set; }
        public string PhoneNumber { get; set; }
        public List<AcademicYearDTO> AcademicYearsDetails { get; set; }
    }
    public class AcademicYearDTO
    {
        public int ID { get; set; }
        public string AcademicYear { get; set; }
        public string Semester { get; set; }
        public string ProgramName { get; set; }
        public int? PassedSemesterHours { get; set; }
        public int SemesterHours { get; set; }
        public decimal? SGPA { get; set; }
        public decimal? CGPA { get; set; }
        public int? CHours { get; set; }
        public List<StudentCoursesDTO> Courses { get; set; }
    }
    public class StudentCoursesDTO
    {
        public int? AcademicYearID { get; set; }
        public string CourseCode { get; set; } = null!;
        public string CourseName { get; set; } = null!;
        public byte CreditHours { get; set; }
        public byte? Mark { get; set; }
        public string? Grade { get; set; }
        public double? Points { get; set; }
        public bool IsApproved { get; set; }
        public bool IsGpaincluded { get; set; }
        public bool IsIncluded { get; set; }
        public byte? CourseEntringNumber { get; set; }
        public bool? AffectReEntringCourses { get; set; }
        public bool? HasExcuse { get; set; }
        public bool? IsEnhancementCourse { get; set; }
    }
}
