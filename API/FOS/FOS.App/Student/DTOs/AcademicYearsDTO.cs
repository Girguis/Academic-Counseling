namespace FOS.App.Students.DTOs
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class AcademicYearsDTO
    {
        public int ID { get; set; }
        public string AcademicYear { get; set; }
        public string Semester { get; set; }
        public double? SGPA { get; set; } = null;
    }
}
