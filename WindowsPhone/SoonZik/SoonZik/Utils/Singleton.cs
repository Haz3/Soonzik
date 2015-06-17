using System;
using System.Diagnostics;
using System.Threading.Tasks;
using Windows.UI.Xaml;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Views;
using News = SoonZik.Views.News;

namespace SoonZik.Utils
{
    public class Singleton
    {
        #region Attribute
        private static Singleton _instance;
        public static Singleton Instance()
        {
            if (_instance == null)
            {
                _instance = new Singleton();
            }
            return _instance;
        }

        public User CurrentUser { get; set; }
        
        public User SelectedUser { get; set; }

        public bool ItsMe { get; set; }

        public News NewsPage { get; set; }

        public ProfilUser ProfilPage { get; set; }

        public int NewProfilUser { get; set; }

        public UIElement LastElement { get; set; }

        public Music SelectedMusicSingleton { get; set; }
        #endregion

        #region Ctor
        protected internal Singleton()
        {

        }
        #endregion

        #region Method
        public async Task Charge()
        {
            var request = new HttpRequestGet();
            try
            {
                SelectedUser = (User)await request.GetObject(new User(), "users", Singleton.Instance().NewProfilUser.ToString());
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }
        #endregion
    }
}
