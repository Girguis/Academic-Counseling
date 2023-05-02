using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class DoctorLoginOutModel
    {
        public byte Type { get; set; }
        public string Guid { get; set; }
        public string ProgramGuid { get; set; }
    }
}
