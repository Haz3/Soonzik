﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.Poco
{
    public class Identities
    {
        public int id { get; set; }
        public int user_id { get; set; }
        public string provider { get; set; }
        public string uid { get; set; }
        public string token { get; set; }
    }
}
