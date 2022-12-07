namespace FOS.App.Student.DTOs
{
    public class AcademicYearsDTO
    {
        public int ID { get; set; }
        public string AcademicYear { get; set; }
        public string Semester { get; set; }
        public double? SGPA { get; set; } = null;
    }
}
