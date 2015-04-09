using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.Poco
{
    public class News
    {
        #region Attributes
        public int Id { get; set; }
        public string Title { get; set; }
        public string Date { get; set; }
        public int AuthorId { get; set; }
        public string CreatedAt { get; set; }
        public string UpdatedAt { get; set; }
        public string NewsType { get; set; }
        public User User { get; set; }
        public List<object> Newstexts { get; set; }
        public List<object> Attachments { get; set; }
        public List<object> Tags { get; set; }
        #endregion
    }
}
