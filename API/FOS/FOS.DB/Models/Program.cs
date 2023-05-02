using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class Program
    {
        public Program()
        {
            Doctors = new HashSet<Doctor>();
            InverseSuperProgram = new HashSet<Program>();
            Students = new HashSet<Student>();
        }

        public int Id { get; set; }
        public string Guid { get; set; } = null!;
        public string Name { get; set; } = null!;
        public byte Semester { get; set; }
        public double Percentage { get; set; }
        public bool IsRegular { get; set; }
        public bool IsGeneral { get; set; }
        public byte TotalHours { get; set; }
        public string EnglishName { get; set; } = null!;
        public string ArabicName { get; set; } = null!;
        public int? SuperProgramId { get; set; }

        public virtual Program? SuperProgram { get; set; }
        public virtual ICollection<Doctor> Doctors { get; set; }
        public virtual ICollection<Program> InverseSuperProgram { get; set; }
        public virtual ICollection<Student> Students { get; set; }
    }
}
