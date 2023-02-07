using System.ComponentModel.DataAnnotations;

namespace FOS.Doctor.API.Models
{
    public class CourseModel
    {
        public int? Id { get; set; } = null;
        public string CourseCode { get; set; } = null!;
        public string CourseName { get; set; } = null!;
        public byte CreditHours { get; set; }
        public byte LectureHours { get; set; }
        public byte LabHours { get; set; }
        public byte SectionHours { get; set; }
        public bool IsActive { get; set; }
        [Range(0,3)]
        public byte PrerequisiteRelation { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public List<int> prequisitesIDs { get; set; } = null;
    }
}
