using System.ComponentModel.DataAnnotations;

namespace FOS.Doctor.API.Models
{
    public class SupervisorModel
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public string Email { get; set; }
        [Required]
        public string Password { get; set; }
        [Required]
        public int ProgramId { get; set; }
    }
}
