using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.Poco
{
    public class Listenings
    {
        public int id { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }
        public string created_at { get; set; }
        public User user { get; set; }
        public Music music { get; set; }
    }
}
