namespace FOS.App.Supervisor.DTOs
{
    public class AcademicYearDTO
    {
        public string AcademicYear { get; set; }
        public string Semester { get; set; }
        public string ProgramName { get; set; }
        public int? PassedSemesterHours { get; set; }
        public int SemesterHours { get; set; }
        public decimal? SGPA { get; set; }
        public decimal? CGPA { get; set; }
        public int? CHours { get; set; }
        public List<StudentCoursesDTO> Courses { get; set; }
    }
}
