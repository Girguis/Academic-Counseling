namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class StudentCoursesSummaryOutModel
    {
        public StudentDataReport Student { get; set; }
        public IEnumerable<CoursesDataReport> Courses { get; set; }
    }
    public class StudentDataReport
    {
        public string AcademicCode { get; set; }
        public string Name { get; set; }
        public string PhoneNumber { get; set; }
        public int Level { get; set; }
        public int PassedHours { get; set; }
        public string ProgramName { get; set; }
        public int TotalHours { get; set; }
        public int RemainingHours { get; set; }

    }
    public class CoursesDataReport
    {
        public int ID { get; set; }
        public int CourseType { get; set; }
        public int Category { get; set; }
        public int Level { get; set; }
        public int Semester { get; set; }
        public int Hours { get; set; }
        public int CreditHours { get; set; }
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public bool IsPassedCourse { get; set; }
        public int RegistrationTimes { get; set; }
        public string SuccessSemester { get; set; }
        public string Grade { get; set; }
    }
}
