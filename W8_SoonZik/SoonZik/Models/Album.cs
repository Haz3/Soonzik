using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Album
    {
        public int id { get; set; }
        public User artist { get; set; }
        public string title { get; set; }
        public Genre genre { get; set; }
        public double price { get; set; }
        public int year { get; set; }
        public List<Music> music_list { get; set; }
    }
}
