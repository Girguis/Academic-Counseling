namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class StudentCoursesGradesOutModel
    {
        public int ID { get; set; }
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public int CreditHours { get; set; }
        public int? Final { get; set; }
        public int? YearWork { get; set; }
        public int? Oral { get; set; }
        public int? Practical { get; set; }
        public float? Points { get; set; }
        public string Grade { get; set; }
        public bool IsGpaIncluded { get; set; }
        public int AcademicYearID { get; set; }
        public int CourseEntringNumber { get; set; }
    }
}
