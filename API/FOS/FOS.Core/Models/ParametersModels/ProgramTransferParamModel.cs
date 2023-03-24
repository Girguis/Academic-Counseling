namespace FOS.Core.Models.ParametersModels
{
    public class ProgramTransferParamModel
    {
        public int ProgramID { get; set; }
        public string ReasonForTransfer { get; set; }
    }
    public class ProgramTransferSearchParamModel
    {
        public int? ToProgramID { get; set; }
        public bool? IsApproved { get; set; }
    }
    public class ProgramTransferHandleParamModel
    {
        public string guid { get; set; }
        public bool IsApproved { get; set; }
    }
}
