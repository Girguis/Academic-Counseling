namespace FOS.Core.Models.StoredProcedureOutputModels
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class DoctorOutModel
    {
        public string Guid { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string ProgramName { get; set; }
        public int ProgramID { get; set; }
        public bool IsActive { get; set; }
        public byte Type { get; set; }

    }
}
