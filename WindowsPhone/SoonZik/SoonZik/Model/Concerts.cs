using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.Foundation;
using Windows.Foundation.Collections;

namespace SoonZik.Model
{
    public class Concerts
    {
        #region Attribute

        private int _id;
        private DateTime _date;
        private Address _addre;
        private string _url;
        private Point _geoloc;

        #endregion

        #region Ctor

        public Concerts()
        {
            
        }
        #endregion
    }
}
