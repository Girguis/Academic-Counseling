namespace FOS.Core.Models
{
    public class GradesSheetUpdateModel
    {
        public int CourseID { get; set; }
        public string AcademicCode { get; set; }
        public byte? Final { get; set; } = null;
        public byte? Oral { get; set; } = null;
        public byte? YearWork { get; set; } = null;
        public byte? Practical { get; set; } = null;
        public short AcademicYearID { get; set; }
    }
}
