using System.Collections.Generic;
using System.Collections.ObjectModel;

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
        public ObservableCollection<User> Friends { get; set; }
        public List<User> Follows { get; set; }
        #endregion
    }
}
