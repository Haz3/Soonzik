using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Address
    {
        public string id { get; set; }
        public string street_nb { get; set; }
        public string complement { get; set; }
        public string street { get; set; }
        public string city { get; set; }
        public string country { get; set; }
        public string zipcode { get; set; }
    }
}
