namespace FOS.Doctors.API.Models
{
    public class StudentCourseModel
    {
        public int StudentID { get; set; }
        public int CourseID { get; set; }
        public int AcademicYearID { get; set; }
        public int? Mark { get; set; }
        public bool IsGPAIncluded { get; set; }
        public bool HasExecuse { get; set; }
    }
}
