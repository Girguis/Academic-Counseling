using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class Student
    {
        public int Id { get; set; }
        public string Guid { get; set; } = null!;
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
        public string Password { get; set; } = null!;
        public string? AcademicCode { get; set; }
        public string? SeatNumber { get; set; }
        public byte AvailableCredits { get; set; }
        public byte? WarningsNumber { get; set; }
        public bool IsInSpecialProgram { get; set; }
        public int SupervisorId { get; set; }
        public DateTime CreatedOn { get; set; }
        public bool IsCrossStudent { get; set; }
        public byte SemestersNumberInProgram { get; set; }
        public decimal? Cgpa { get; set; }
        public byte? PassedHours { get; set; }
        public byte? Level { get; set; }
        public bool? IsGraduated { get; set; }
        public short? Rank { get; set; }
        public short? CalculatedRank { get; set; }
        public bool? IsActive { get; set; }

        public virtual Supervisor Supervisor { get; set; } = null!;
    }
}
