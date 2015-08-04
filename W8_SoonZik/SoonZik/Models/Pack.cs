using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Pack
    {
        public int id { get; set; }
        public string title { get; set; }
        public double price { get; set; }
        public List<Album> albums { get; set; }
    }
}
