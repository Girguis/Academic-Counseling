using System.ComponentModel.DataAnnotations;

namespace FOS.Doctors.API.Models
{
    public class DoctorAddModel
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public string Email { get; set; }
        [Required]
        [RegularExpression("^(?=.*\\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\\w\\d\\s:])([^\\s]){8,16}$")]
        public string Password { get; set; }
        [Required]
        public int ProgramId { get; set; }
        [Required]
        [Range(1,3)]
        public byte Type { get; set; }
    }
    public class DoctorUpdateModel
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public string Email { get; set; }
        [Required]
        public int ProgramId { get; set; }
        [Required]
        [Range(1, 3)]
        public byte Type { get; set; }
    }
}
