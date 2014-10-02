using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Users
    {
        #region Attribute

        private int _id;
        private string _email;
        private string _fristName;
        private string _lastName;
        private DateTime _birthday;
        private string _pathImage;
        private string _description;
        private string _phoneNumber;
        private Address _addre;
        private string _facebook;
        private string _twitter;
        private string _gplus;
        private string _idApi;
        private string _signin;
        private bool _activated;

        #endregion

        #region Ctor

        public Users()
        {
            
        }
        #endregion
    }
}
