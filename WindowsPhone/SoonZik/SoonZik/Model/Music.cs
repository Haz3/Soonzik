using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Music
    {
        #region Attribute

        private int _id;
        private string _title;
        private int _duration;
        private string _style;
        private float _price;
        private string _file;
        private Users _artist;
        private Album _album;
        private bool _limited;

        #endregion

        #region Ctor

        public Music()
        {
            
        }
        #endregion
    }
}
