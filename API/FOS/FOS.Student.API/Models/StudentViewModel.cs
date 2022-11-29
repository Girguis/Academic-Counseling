using FOS.DB.Models;

namespace FOS.Student.API.Models
{
    public class StudentViewModel
    {
        public string Fname { get; set; }
        public string MName { get; set; }
        public string LName { get; set; }
        public String FullName
        {
            get
            {
                return Fname + " " + MName + " " + LName;
            }
        }
        public string PhoneNumber { get; set; }
        public string SupervisorName { get; set; }
        public byte? NumberOfWarnings { get; set; }
        public byte? Level { get; set; }
        public decimal? CGpa { get; set; }  
    }
}
