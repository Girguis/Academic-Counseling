using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Models.ParametersModels
{
    public class AddCourseParamModel
    {
        //[RegularExpression(@"^([A-Z]){1,10}\s([\d]){3}$")]
        public string CourseCode { get; set; } = null!;
        public string CourseName { get; set; } = null!;
        public byte CreditHours { get; set; }
        public byte LectureHours { get; set; }
        public byte LabHours { get; set; }
        public byte SectionHours { get; set; }
        public bool IsActive { get; set; }
        public byte Level { get; set; }
        public byte Semester { get; set; }
        public int Final { get; set; }
        public int YearWork { get; set; }
        public int Oral { get; set; }
        public int Practical { get; set; }
    }
}
