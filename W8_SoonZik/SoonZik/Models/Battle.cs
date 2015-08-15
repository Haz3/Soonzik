using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace SoonZik.Models
{
    public class Battle
    {
        public int id { get; set; }
        public DateTime date_begin { get; set; }
        public DateTime date_end { get; set; }
        public User artist_one { get; set; }
        public User artist_two { get; set; }
        //public float vote_artist1 { get; set; }
        //public float vote_artist2 { get; set; }
    }

    public class Votes
    {
        public int id { get; set; }
        public int user_id { get; set; }
        public int battle_id { get; set; }
        public int artist_id { get; set; }
    }
}