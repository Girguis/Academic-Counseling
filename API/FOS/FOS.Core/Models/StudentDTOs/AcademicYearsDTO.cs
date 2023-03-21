namespace FOS.Core.StudentDTOs
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class AcademicYearsDTO
    {
        public int ID { get; set; }
        public string AcademicYear { get; set; }
        public int Semester { get; set; }
        public double? SGPA { get; set; } = null;
        public double? CGPA { get; set; } = null;
        public string ProgramName { get; set; }
    }
}
