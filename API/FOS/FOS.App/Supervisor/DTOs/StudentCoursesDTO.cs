namespace FOS.App.Supervisor.DTOs
{
    public class StudentCoursesDTO
    {
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
        public bool? HasExecuse { get; set; }
        public bool? IsEnhancementCourse { get; set; }
    }
}
