namespace FOS.Doctors.API.Models
{
    public class CourseModel
    {
        public string CourseCode { get; set; } = null!;
        public string CourseName { get; set; } = null!;
        public byte CreditHours { get; set; }
        public byte LectureHours { get; set; }
        public byte LabHours { get; set; }
        public byte SectionHours { get; set; }
        public bool IsActive { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }

    }
}
