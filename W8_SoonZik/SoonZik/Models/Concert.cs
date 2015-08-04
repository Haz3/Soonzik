using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Concert
    {
        public int id { get; set; }
        public string name { get; set; }
        public User user { get; set; }
        public DateTime planification { get; set; }
        public Address address { get; set; }
        public string url { get; set; }
    }
}
