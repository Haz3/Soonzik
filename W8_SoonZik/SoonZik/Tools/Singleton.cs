using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;

namespace SoonZik.Tools
{
    class Singleton
    {
        private static Singleton instance = null;

        public User Current_user;
        public string secureKey { get; set; }
        public DateTime compare_date { get; set; }

        // Private ctor
        private Singleton(){}

        public static Singleton Instance
        {
            get
            {
                if (instance == null)
                {
                    instance = new Singleton();
                }
                return instance;
            }
        }
    }
}

