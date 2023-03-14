namespace FOS.Core.Models.ParametersModels
{
    public class ProgramBasicDataUpdateParamModel
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public byte Semester { get; set; }
        public double Percentage { get; set; }
        public bool IsRegular { get; set; }
        public bool IsGeneral { get; set; }
        public byte TotalHours { get; set; }
        public string EnglishName { get; set; } = null!;
        public string ArabicName { get; set; } = null!;
        public int? SuperProgramId { get; set; }
    }
    public class ProgramBasicDataDTO : ProgramBasicDataUpdateParamModel
    {
        public string SuperProgramName { get; set; }
    }
}
