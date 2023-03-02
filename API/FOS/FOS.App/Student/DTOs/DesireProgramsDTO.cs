namespace FOS.App.Students.DTOs
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class DesireProgramsDTO
    {
        public int ProgramID { get; set; }
        public string ProgramName { get; set; }
        public int DesireNumber { get; set; }
    }
}
