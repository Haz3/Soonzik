using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Address
    {
        #region Attribute

        private int _id;
        private int _streetNb;
        private string _complement;
        private string _street;
        private string _city;
        private string _country;
        private string _zipCode;

        #endregion

        #region Ctor

        public Address()
        {
            
        }
        #endregion
    }
}
