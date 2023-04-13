namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class GetReportByCgpaOutModel
    {
        public string Name { get; set; }
        public string PhoneNumber { get; set; }
        public string AcademicCode { get; set; }
        public decimal Cgpa { get; set; }
        public int PassedHours { get; set; }
        public int Level { get; set; }
        public string EnrollYear { get; set; }
        public string GraduationYear { get; set; }
        public byte GraduationSemester { get; set; }
        public string ProgramName { get; set; }
    }
}
