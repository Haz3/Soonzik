using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Comment
    {
        public int id { get; set; }
        public User author { get; set; }
        public string content { get; set; }
        public DateTime date { get; set; }

    }
}
