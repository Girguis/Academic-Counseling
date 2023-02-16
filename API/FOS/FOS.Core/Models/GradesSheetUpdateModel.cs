namespace FOS.Core.Models
{
    public class GradesSheetUpdateModel
    {
        public int CourseID { get; set; }
        public string AcademicCode { get; set; }
        public byte? Mark { get; set; } = null;
        public short AcademicYearID { get; set; }
    }
}
