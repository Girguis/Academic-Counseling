using System.Text.Json.Serialization;

namespace FOS.Core.Models.ParametersModels
{
    public class ProgramBasicDataUpdateParamModel
    {
        [JsonIgnore]
        public int Id { get; set; }
        public string Guid { get; set; }
        public string Name { get; set; } = null!;
        public byte Semester { get; set; }
        public double Percentage { get; set; }
        public bool IsRegular { get; set; }
        public bool IsGeneral { get; set; }
        public byte TotalHours { get; set; }
        public string EnglishName { get; set; } = null!;
        public string ArabicName { get; set; } = null!;
        [JsonIgnore]
        public int? SuperProgramId { get; set; }
        public string SuperProgramGuid { get; set; }

    }
    public class ProgramBasicDataDTO : ProgramBasicDataUpdateParamModel
    {
        public string SuperProgramName { get; set; }
    }
}
