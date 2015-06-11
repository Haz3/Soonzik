using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Collections;
using SoonZik.ViewModels;

namespace SoonZik.Models
{
    public class News
    {
        public int id { get; set; }
        public string title { get; set; }
        public string content { get; set; }
        public User author { get; set; }
        public string type { get; set; }
        public DateTime date { get; set; }
        public List<Comment> comment_list { get; set; }
    }
}
