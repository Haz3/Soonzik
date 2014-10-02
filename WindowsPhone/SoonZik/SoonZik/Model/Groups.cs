using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Groups
    {
        #region Attribute

        private int _id;
        private string _name;
        private List<Users> _usersList;

        #endregion

        #region Ctor

        public Groups()
        {
            
        }
        #endregion
    }
}
