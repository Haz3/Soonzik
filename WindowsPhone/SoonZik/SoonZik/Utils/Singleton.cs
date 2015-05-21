using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.Utils
{
    public class Singleton
    {
        #region Attribute
        private static Singleton _instance;
        public static Singleton Instance()
        {
            if (_instance == null)
            {
                _instance = new Singleton();
            }
            return _instance;
        }

        public User CurrentUser { get; set; }

        #endregion

        #region Ctor
        protected internal Singleton()
        {

        }
        #endregion
    }
}
