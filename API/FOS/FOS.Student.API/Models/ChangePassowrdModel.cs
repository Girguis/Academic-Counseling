﻿using System.ComponentModel.DataAnnotations;

namespace FOS.Student.API.Models
{
    public class ChangePasswordModel
    {
        [Required]
        [RegularExpression("^(?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\\w\\d\\s:])([^\\s]){8,16}$")]
        public string Password { get; set; }
    }
}