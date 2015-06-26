using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Music
    {
        public int id { get; set; }
        public string title { get; set; }
        public int duration { get; set; }
        public double price { get; set; }
        public string file { get; set; }
        public Album album { get; set; }
        public List<Genre> genres { get; set; }
        public User user { get; set; }
    }
}
