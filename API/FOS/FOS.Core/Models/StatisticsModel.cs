namespace FOS.Core.Models
{
    public class StatisticsModel
    {
        public object Key { get; set; }
        public int Value { get; set; }
    }
    public class StudentsGradesParatmeterModel
    {
        public int? ProgramID { get; set; } = null;
        public bool IsActive { get; set; } = true;
        public bool IsGraudated { get; set; } = false;
    }
}
