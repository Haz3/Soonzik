using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest
{
    public class CreateRequete
    {
        #region Attribute

        public Uri Uri { get; set; }

        #endregion

        #region ctor

        public CreateRequete(string obj, string id)
        {
            Uri = new Uri("http://soonzikapi.herokuapp.com/" + obj + "/" + id);
        }
        #endregion

        #region Method

        #endregion
    }
}
