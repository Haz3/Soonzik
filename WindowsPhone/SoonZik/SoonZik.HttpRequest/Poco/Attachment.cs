using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.Poco
{
    public class Attachment
    {
        public int id { get; set; }
        public string url { get; set; }
        public int file_size { get; set; }
        public string content_type { get; set; }
    }
}
