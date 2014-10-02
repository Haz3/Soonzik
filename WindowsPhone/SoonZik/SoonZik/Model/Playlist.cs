using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Playlist
    {
        #region Attribute

        private int _id;
        private string _title;
        private List<Music> _listMusics;

        #endregion

        #region Ctor

        public Playlist()
        {
            
        }
        #endregion
    }
}
