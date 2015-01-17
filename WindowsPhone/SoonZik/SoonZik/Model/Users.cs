using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.Model
{
    public class Users
    {
        #region Attribute

        private int _id;
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
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

        public string MyLastName;

        #endregion

        #region Ctor

        public Users(string firstName, string lastName, string email)
        {
            FirstName = firstName;
            LastName = lastName;
            Email = email;
            MyLastName = LastName;
        }
        #endregion
    }
}
