using System.Collections.Generic;

namespace SoonZik.HttpRequest.Poco
{
    public class Album
    {
        #region Attributes    
        public int id { get; set; }
        public string title { get; set; }
        public string image { get; set; }
        public int price { get; set; }
        public int yearProd { get; set; }
        public int getAverageNote { get; set; }
        public User user { get; set; }
        public List<Music> musics { get; set; }
        public List<Genre> genres { get; set; }
        public List<Description> descriptions { get; set; }
        #endregion
    }
}
