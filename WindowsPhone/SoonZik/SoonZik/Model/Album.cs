using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Album
    {
        #region Attribute

        private int _id;
        private string _titre;
        private Genre _style;
        private List<Music> _listMusics;
        private float _price;
        private string _image;
        private int _yearProd;

        #endregion

        #region Ctor

        public Album()
        {
            
        }
        #endregion


    }
}
