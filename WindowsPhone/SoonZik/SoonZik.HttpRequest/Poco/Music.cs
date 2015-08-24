using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Music
    {
        public int id { get; set; }
        public string title { get; set; }
        public string file { get; set; }
        public int duration { get; set; }
        public string price { get; set; }
        public bool limited { get; set; }
        public string getAverageNote { get; set; }
        public Album album { get; set; }
        public List<Genre> genres { get; set; }
        public User user { get; set; }
        public List<Description> descriptions { get; set; }
    }
}
