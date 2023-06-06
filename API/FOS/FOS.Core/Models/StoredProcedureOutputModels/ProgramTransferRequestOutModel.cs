namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class ProgramTransferRequestOutModel
    {
        public string CurrentProgramName { get; set; }
        public string ToProgramName { get; set; }
        public string ReasonForTransfer { get; set; }
        public string StudentName { get; set; }
        public int StudentLevel { get; set; }
        public float? StudentGPA { get; set; }
        public string GUID { get; set; }
        public bool? IsApproved { get; set; }
    }
}
