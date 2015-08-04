﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Models
{
    public class Album
    {
        public int id { get; set; }
        public string title { get; set; }
        public User user { get; set; }
        public double price { get; set; }
        public int yearProd { get; set; }
        public string image { get; set; }
        public List<Music> musics { get; set; }
    }
}
