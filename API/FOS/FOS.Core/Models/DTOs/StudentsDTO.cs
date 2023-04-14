namespace FOS.Core.Models.DTOs
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class StudentsDTO
    {
        public string Name { get; set; }
        public string Guid { get; set; }
        public decimal? Cgpa { get; set; }
        public byte PassedHours { get; set; }
        public byte Level { get; set; }
        public byte WarningsNumber { get; set; }
        public int? ProgramID { get; set; }
        public string ProgramName { get; set; }
        public string Ssn { get; set; }
        public string PhoneNumber { get; set; }
        public string Address { get; set; }
        public string Gender { get; set; }
        public string AcademicCode { get; set; }
        public string SeatNumber { get; set; }
        public byte AvailableCredits { get; set; }
        public int? SupervisorID { get; set; }
        public string SupervisorName { get; set; }
        public int RegisteredHours { get; set; }
        public int CoursesCount { get; set; }

    }
}
