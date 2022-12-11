namespace FOS.App.Supervisor.DTOs
{
    public class StudentAcademicReportDTO
    {
        public string Fname { get; set; }
        public string Mname { get; set; }
        public string Lname { get; set; }
        public string SSN { get; set; }
        public decimal? Cgpa { get; set; }
        public string ProgramName { get; set; }
        public List<AcademicYearDTO> academicYearsDetails { get; set; }
    }
}
