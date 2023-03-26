namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class StudentCoursesSummaryTreeOutModel
    {
        public IEnumerable<ProgramCoursesOutModel> ProgramCourses;
        public IEnumerable<StudentCourseDetailsOutModel> StudentCourses;
    }
    public class ProgramCoursesOutModel
    {
        public int ID { get; set; }
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public int CreditHours { get; set; }
    }
    public class StudentCourseDetailsOutModel
    {
        public int CourseID { get; set; }
        public int? Mark { get; set; }
        public string Grade { get; set; }
        public int AcademicYearID { get; set; }
        public string AcademicYear { get; set; }
        public int Semester { get; set; }
    }
}
