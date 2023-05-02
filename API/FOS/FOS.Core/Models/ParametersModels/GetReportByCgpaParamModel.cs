namespace FOS.Core.Models.ParametersModels
{
    public class GetReportByCgpaParamModel
    {
        public decimal? FromCgpa { get; set; }
        public decimal? ToCgpa { get; set; }
        public byte? Level { get; set; }
        public string ProgramID { get; set; }
        public bool IsGraduated { get; set; }
        public byte? StartGraduationYearID { get; set; }
        public byte? EndGraduationYearID { get; set; }
    }
}