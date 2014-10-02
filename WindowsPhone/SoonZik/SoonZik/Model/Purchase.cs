using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Purchase
    {
        #region Attribute

        private int _id;
        private Album _album;
        private Pack _pack;
        private Music _music;
        private DateTime _date;
        private bool _gift;

        #endregion

        #region Ctor

        public Purchase()
        {
            
        }
        #endregion
    }
}
