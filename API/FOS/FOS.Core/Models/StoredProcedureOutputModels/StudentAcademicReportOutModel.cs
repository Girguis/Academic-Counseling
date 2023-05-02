namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class StudentCoursesGradesOutModel
    {
        public int ID { get; set; }
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public byte CreditHours { get; set; }
        public byte? Mark { get; set; }
        public byte? Final { get; set; }
        public byte? YearWork { get; set; }
        public byte? Oral { get; set; }
        public byte? Practical { get; set; }
        public float? Points { get; set; }
        public string Grade { get; set; }
        public bool IsGpaIncluded { get; set; }
        public int AcademicYearID { get; set; }
        public int CourseEntringNumber { get; set; }
        public bool HasExcuse { get; set; }
    }
}
