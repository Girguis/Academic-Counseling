using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FOS.Core.SearchModels
{
    public sealed class SearchBaseModel
    {
        public string Key { get; set; }
        public string Operator { get; set; } = "=";
        public object Value { get; set; }
    }
}
