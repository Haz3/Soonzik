using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Battle
    {
        public int id { get; set; }
        public DateTime date_start { get; set; }
        public DateTime date_end { get; set; }
        public User artist1 { get; set; }
        public User artist2 { get; set; }
        public float vote_artist1 { get; set; }
        public float vote_artist2 { get; set; }
    }
}