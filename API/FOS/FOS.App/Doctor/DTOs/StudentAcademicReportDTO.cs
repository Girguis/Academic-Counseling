namespace FOS.App.Doctors.DTOs
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
        public string SupervisorName { get; set; }
        public byte AvailableCredits { get; set; }
        public string PhoneNumber { get; set; }
        public short? Rank { get; set; }
        public List<AcademicYearDTO> academicYearsDetails { get; set; }
    }
}
