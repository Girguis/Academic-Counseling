namespace FOS.Core.Models.ParametersModels
{
    public class StruggledStudentsParamModel
    {
        public string? ProgramID { get; set; }
        public bool IsActive { get; set; } = true;
        public int WarningsNumber { get; set; } = 5;
    }
}
