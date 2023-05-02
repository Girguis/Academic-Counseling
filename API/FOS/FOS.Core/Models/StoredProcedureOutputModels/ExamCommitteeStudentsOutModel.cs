namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class ExamCommitteeStudentsOutModel
    {
        public CourseOutModel Course { get; set; }
        public List<StudentOutModel> Students { get; set; }

    }
    public class CourseOutModel
    {
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public int CreditHours { get; set; }
        public byte Final { get; set; }
        public byte YearWork { get; set; }
        public byte Oral { get; set; }
        public byte Practical { get; set; }
    }
    public class StudentOutModel
    {
        public string Name { get; set; }
        public string AcademicCode { get; set; }
        public string Level { get; set; }
        public string ProgramName { get; set; }
    }
}
