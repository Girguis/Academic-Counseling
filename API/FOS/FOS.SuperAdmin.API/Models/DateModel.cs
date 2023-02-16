using System.ComponentModel.DataAnnotations;

namespace FOS.Doctor.API.Models
{
    public class DateModel
    {
        [Required]
        [DataType(DataType.DateTime)]
        public DateTime? StartDate { get; set; }
        [Required]
        [DataType(DataType.DateTime)]
        public DateTime? EndDate { get; set; }
    }
}
