namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class ExamCommitteeStudentsOutModel
    {
        public ProgramOutModel Program { get; set; }
        public CourseOutModel Course { get; set; }
        public List<StudentOutModel> Students { get; set; }

    }
    public class ProgramOutModel
    {
        public string Name { get; set; }
    }
    public class CourseOutModel
    {
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public int CreditHours { get; set; }
    }
    public class StudentOutModel
    {
        public string Name { get; set; }
        public string AcademicCode { get; set; }
        public string Level { get; set; }
    }
}
