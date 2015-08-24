using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Pack
    {
        public int id { get; set; }
        public string title { get; set; }
        public string price { get; set; }
        public List<Album> albums { get; set; }
        public List<Description> descriptions { get; set; }
    }
}
