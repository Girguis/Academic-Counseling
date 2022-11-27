using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class SuperAdmin
    {
        public int Id { get; set; }
        public string Guid { get; set; } = null!;
        public string Fname { get; set; } = null!;
        public string Mname { get; set; } = null!;
        public string Lname { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
        public int ProgramId { get; set; }

        public virtual Program Program { get; set; } = null!;
    }
}
