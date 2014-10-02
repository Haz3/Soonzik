using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.Security.Authentication.OnlineId;

namespace SoonZik.Model
{
    public class Gift
    {
        #region Attribute
        private int _id;
        private Users _from;
        private Users _to;
        private string _type;
        private Object _object;
        #endregion

        #region Ctor
        public Gift()
        {

        }
        #endregion
    }
}
