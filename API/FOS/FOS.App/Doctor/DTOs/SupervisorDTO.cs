namespace FOS.App.Doctor.DTOs
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class SupervisorDTO
    {
        public string Guid { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string ProgramName { get; set; }
    }
}
