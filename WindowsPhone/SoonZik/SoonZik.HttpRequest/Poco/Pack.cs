using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Pack
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string CreatedAt { get; set; }
        public string UpdatedAt { get; set; }
        public List<Album> Albums { get; set; }
    }
}
