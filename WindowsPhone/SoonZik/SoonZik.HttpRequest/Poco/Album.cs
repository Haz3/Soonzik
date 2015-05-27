using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace SoonZik.HttpRequest.Poco
{
    public class Album
    {
        #region Attributes
        public int id { get; set; }
        public int user_id { get; set; }
        public string title { get; set; }
        public string image { get; set; }
        public double price { get; set; }
        public string file { get; set; }
        public int yearProd { get; set; }
        public string created_at { get; set; }
        public string updated_at { get; set; }
        public List<Music> musics { get; set; }
        public User user { get; set; }
        #endregion
    }
}
