using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.Poco
{
    public class Concerts
    {
        public int id { get; set; }
        public string planification { get; set; }
        public string url { get; set; }
        public Address address { get; set; }
        public User user { get; set; }
    }
}
