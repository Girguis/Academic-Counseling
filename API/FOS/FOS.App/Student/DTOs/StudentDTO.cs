﻿using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.App.Students.DTOs
{
    /// <summary>
    /// Model which will be sent to the client
    /// </summary>
    public class StudentDTO
    {
        public string Name { get; set; } = null!;
        public string DoctorName { get; set; } = null!;
        public string ProgramName { get; set; }
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
        public bool IsInSpecialProgram { get; set; }
        public decimal? Cgpa { get; set; }
        public byte? PassedHours { get; set; }
        public byte? Level { get; set; }
        public string academicYear { get; set; }
        public byte semester { get; set; }
        public List<StudentCoursesOutModel> Courses { get; set; }
    }
}
