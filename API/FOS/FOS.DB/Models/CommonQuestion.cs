using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class CommonQuestion
    {
        public int Id { get; set; }
        public string Question { get; set; } = null!;
        public string Answer { get; set; } = null!;
    }
}
