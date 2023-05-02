namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class CourseGradesSheetOutModel
    {
        public CourseOutModel Course { get; set; }
        public AcademicYearOutModel YearModel { get; set; }
        public List<StudentMarkOutModel> Students { get; set; }
    }
    public class AcademicYearOutModel
    {
        public string Year { get; set; }
        public int Semester { get; set; }
    }
    public class StudentMarkOutModel
    {
        public string AcademicCode { get; set; }
        public string Name { get; set; }
        public int Level { get; set; }
        public string ProgramName { get; set; }
        public byte? Final { get; set; } = null;
        public byte? Oral { get; set; } = null;
        public byte? YearWork { get; set; } = null;
        public byte? Practical { get; set; } = null;
    }
}