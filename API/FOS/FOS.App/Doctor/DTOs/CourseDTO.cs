using FOS.DB.Models;

namespace FOS.App.Doctor.DTOs
{
    public class CourseDTO
    {
        public int Id { get; set; }
        public string CourseCode { get; set; } = null!;
        public string CourseName { get; set; } = null!;
        public byte CreditHours { get; set; }
        public byte LectureHours { get; set; }
        public byte LabHours { get; set; }
        public byte SectionHours { get; set; }
        public bool IsActive { get; set; }
        public byte PrerequisiteRelation { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public List<Prerequisite> Prerequisites { get; set; }
    }
    public class Prerequisite
    {
        public int Id { get; set; }
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
    }
}
