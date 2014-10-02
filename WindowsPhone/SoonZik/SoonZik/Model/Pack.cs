using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Pack
    {
        #region Attribute

        private int _id;
        private string _title;
        private Genre _genre;
        private List<Album> _listAlbums;

        #endregion

        #region Ctor

        public Pack()
        {
            
        }
        #endregion
    }
}
