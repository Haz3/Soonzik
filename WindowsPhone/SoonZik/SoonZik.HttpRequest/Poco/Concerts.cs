namespace SoonZik.HttpRequest.Poco
{
    public class Concerts
    {
        public int id { get; set; }
        public string planification { get; set; }
        public string url { get; set; }
        public Address address { get; set; }
        public User user { get; set; }
    }
}