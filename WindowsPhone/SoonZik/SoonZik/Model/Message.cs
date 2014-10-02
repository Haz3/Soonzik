using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Message
    {
        #region Attribute

        private int _id;
        private string _mess;
        private Users _userSend;
        private Users _userDest;
        private DateTime _date;

        #endregion

        #region Ctor

        public Message()
        {
            
        }
        #endregion
    }
}
