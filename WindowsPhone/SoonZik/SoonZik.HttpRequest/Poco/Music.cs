using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.Poco
{
    public class Music
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int Duration { get; set; }
        public double Price { get; set; }
        public string File { get; set; }
        public Album Album { get; set; }
        public List<object> Genres { get; set; }
        public User User { get; set; }
    }
}
