namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class StruggledStudentsOutModel
    {
        public string Name { get; set; }
        public string AcademicCode { get; set; }
        public string PhoneNumber { get; set; }
        public int AvailableCredits { get; set; }
        public int WarningsNumber { get; set; }
        public double CGPA { get; set; }
        public int Level { get; set; }
        public int PassedHours { get; set; }
        public string ProgramName { get; set; }
    }
}
