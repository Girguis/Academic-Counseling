using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class Program
    {
        public Program()
        {
            SuperAdmins = new HashSet<SuperAdmin>();
            Supervisors = new HashSet<Supervisor>();
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public byte Semester { get; set; }
        public double Percentage { get; set; }
        public bool IsRegular { get; set; }
        public bool IsGeneral { get; set; }

        public virtual ICollection<SuperAdmin> SuperAdmins { get; set; }
        public virtual ICollection<Supervisor> Supervisors { get; set; }
    }
}
