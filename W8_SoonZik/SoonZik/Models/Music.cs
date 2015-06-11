using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Music
    {
        public int id { get; set; }
        public string title { get; set; }
        public User artist { get; set; }
        public Album album { get; set; }
        public Genre genre { get; set; }
        public int duration { get; set; }
        public int price { get; set; }
        public string file { get; set; }
        public string flac_file { get; set; }
        public bool is_limited { get; set; }
    }
}
