using FOS.DB.Models;

namespace FOS.App.Student.DTOs
{
    public class StudentDTO
    {
        public string Fname { get; set; } = null!;
        public string Mname { get; set; } = null!;
        public string Lname { get; set; } = null!;
        public string Ssn { get; set; } = null!;
        public string PhoneNumber { get; set; } = null!;
        public DateTime BirthDate { get; set; }
        public string Address { get; set; } = null!;
        public string Gender { get; set; } = null!;
        public string Nationality { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? AcademicCode { get; set; }
        public byte AvailableCredits { get; set; }
        public byte? WarningsNumber { get; set; }
        public short? Rank { get; set; }
        public bool IsInSpecialProgram { get; set; }
        public decimal? Cgpa { get; set; }
        public byte? PassedHours { get; set; }
        public byte? Level { get; set; }
        public string academicYear { get; set; }
        public byte semester { get; set; }
        public List<StudentCoursesDTO> Courses { get; set; }
    }
}
