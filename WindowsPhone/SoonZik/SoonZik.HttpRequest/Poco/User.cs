using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest.Poco
{
    public class User
    {
        #region Attribute
        public int Id { get; set; }
        public string Email { get; set; }
        public string Username { get; set; }
        public string Image { get; set; }
        public string Description { get; set; }
        public string Language { get; set; }
        public Address Address { get; set; }
        public List<object> Friends { get; set; }
        public List<object> Follows { get; set; }
        #endregion
    }
}
