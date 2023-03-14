namespace FOS.Core.Models.ParametersModels
{
    public class StudentsGradesParatmeterModel
    {
        public int? ProgramID { get; set; } = null;
        public bool IsActive { get; set; } = true;
        public bool IsGraudated { get; set; } = false;
    }
    public class CourseStatisticsParameterModel
    {
        public int CourseID { get; set; }
        public int? AcademicYearID { get; set; }
    }
}
