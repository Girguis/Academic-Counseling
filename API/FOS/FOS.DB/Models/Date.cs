using System;
using System.Collections.Generic;

namespace FOS.DB.Models
{
    public partial class Date
    {
        public byte DateFor { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }
}
