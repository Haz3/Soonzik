using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class News
    {
        #region Attribute

        private int _id;
        private string _title;
        private string _content;
        private int _idAuthor;
        private string _type;
        private DateTime _date;
        private Dictionary<ValueType, string> _attachement;

        #endregion

        #region Ctor

        public News()
        {
            
        }
        #endregion
    }
}
