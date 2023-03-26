namespace FOS.Core.Models.StoredProcedureOutputModels
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class DesireProgramsOutModel
    {
        public int ProgramID { get; set; }
        public string ProgramName { get; set; }
        public int DesireNumber { get; set; }
    }
}
