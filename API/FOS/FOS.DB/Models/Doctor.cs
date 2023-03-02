using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class Doctor
    {
        public Doctor()
        {
            Students = new HashSet<Student>();
        }

        public int Id { get; set; }
        public string Guid { get; set; } = null!;
        public string Name { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
        public bool IsActive { get; set; }
        public DateTime CreatedOn { get; set; }
        public int ProgramId { get; set; }
        public byte Type { get; set; }

        public virtual Program Program { get; set; } = null!;
        public virtual ICollection<Student> Students { get; set; }
    }
}
