using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class SuperAdmin
    {
        public int Id { get; set; }
        public string Guid { get; set; } = null!;
        public string Name { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string Password { get; set; } = null!;
    }
}
