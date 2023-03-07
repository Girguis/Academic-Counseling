using System.ComponentModel.DataAnnotations;

namespace FOS.Doctors.API.Models
{
    public class ChangePasswordModel
    {
        [Required]
        [RegularExpression("^.*(?=.{8,16})(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z\\d\\s:]).*$")]
        public string Password { get; set; }
    }
}
