using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class User
    {
        public int id { get; set; }
        public string mail { get; set; }
        public string fname { get; set; }
        public string lname { get; set; }
        public string username { get; set; }
        public Address address { get; set; }
        public string phone { get; set; }
        public string birthday { get; set; }
        public string description { get; set; }
        public string avatar { get; set; }
        public List<User> friend_list { get; set; }
        public List<User> follow_list { get; set; }
    }
}
