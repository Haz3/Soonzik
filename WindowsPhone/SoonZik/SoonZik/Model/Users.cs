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
        public DateTime Birthday { get; set; }
        public string PathImage { get; set; }
        public string Description { get; set; }
        public string PhoneNumber { get; set; }
        public Address Addre { get; set; }
        public string Facebook { get; set; }
        public string Twitter { get; set; }
        public string Gplus { get; set; }
        public string IdApi { get; set; }
        public string Signin { get; set; }
        public bool Activated { get; set; }

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
