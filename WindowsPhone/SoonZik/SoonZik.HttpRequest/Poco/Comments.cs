﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.Poco
{
    public class Comments
    {
        public int id { get; set; }
        public int author_id { get; set; }
        public string content { get; set; }
        public string created_at { get; set; }
        public User user { get; set; }
    }
}
