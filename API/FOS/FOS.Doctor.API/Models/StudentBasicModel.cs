﻿using System.ComponentModel.DataAnnotations;

namespace FOS.Doctors.API.Models
{
    public class StudentBasicModel
    {
        public string Name { get; set; }
        public string Ssn { get; set; }
        public int SeatNumber { get; set; }
        public byte NumberOfSemesters { get; set; }
    }
    public class GuidModel
    {
        [Required]
        public string Guid { get; set; }
    }
}
