using FOS.Core.Models.ParametersModels;
using FOS.DB.Models;

namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class ProgramDetailsOutModel
    {
        public ProgramBasicDataDTO BasicData { get; set; }
        public List<ProgramDistribution> ProgramHoursDistribution { get; set; }
        public List<CoursesDetailsForExcel> Courses { get; set; }
    }
    public class CoursesDetailsForExcel
    {
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public byte PrerequisiteRelationID { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public byte CreditHours { get; set; }
        public byte CourseType { get; set; }
        public byte Category { get; set; }
        public short? DeletionYearID { get; set; }
        public short AddtionYearID { get; set; }
        public string Prerequisites { get; set; }
        public int? AllowedHours { get; set; }
    }
}
