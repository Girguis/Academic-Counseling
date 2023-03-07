using System.ComponentModel.DataAnnotations;

namespace FOS.Students.API.Models
{
    public class ChangePasswordModel
    {
        [Required]
        [RegularExpression("^.*(?=.{8,16})(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^a-zA-Z\\d\\s:]).*$")]
        public string Password { get; set; }
    }
}
