namespace FOS.App.Supervisor.DTOs
{
    public class StudentWarningsDTO
    {
        public string Fname { get; set; }
        public string Mname { get; set; }
        public string Lname { get; set; }
        public string Guid { get; set; }
        public decimal? Cgpa { get; set; }
        public byte? PassedHours { get; set; }
        public byte? Level { get; set; }
        public byte? WarningsNumber { get; set; }
    }
}
