using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Influence
    {
        public int id { get; set; }
        public string name { get; set; }
        public List<Genre> genres { get; set; }
    }
}