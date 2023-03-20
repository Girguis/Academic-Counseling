namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class CourseRegistrationOutModel
    {
        public int Id { get; set; }
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public byte CreditHours { get; set; }
        public byte LectureHours { get; set; }
        public byte LabHours { get; set; }
        public byte SectionHours { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public byte CourseType { get; set; }
        public byte Category { get; set; }
        public bool IsSelected { get; set; }
    }
}
