using System.ComponentModel.DataAnnotations;

namespace FOS.Doctors.API.Models
{
    public class UtcOffsetModel
    {
        [Range(1,24)]
        public int UtcOffset { get; set; }
    }
}
