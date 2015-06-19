using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace SoonZik.HttpRequest.Poco
{
    public class User
    {
        #region Attribute
        public int id { get; set; }
        public string email { get; set; }
        public string salt { get; set; }
        public string fname { get; set; }
        public string lname { get; set; }
        public string username { get; set; }
        public string birthday { get; set; }
        public string image { get; set; }
        public object description { get; set; }
        public object phoneNumber { get; set; }
        public object facebook { get; set; }
        public object twitter { get; set; }
        public object googlePlus { get; set; }
        public bool newsletter { get; set; }
        public string language { get; set; }
        public string created_at { get; set; }
        public Address address { get; set; }
        public ObservableCollection<User> friends { get; set; }
        public List<User> follows { get; set; }
        #endregion
    }
}
