using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Facebook;
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

        public FacebookClient MyFacebookClient { get; set; }
        #endregion

        #region Ctor
        protected internal Singleton()
        {

        }
        #endregion

        #region Method
        public void Charge()
        {
            var request = new HttpRequestGet();
            //try
            //{
            //    SelectedUser = (User)await request.GetObject(new User(), "users", Singleton.Instance().NewProfilUser.ToString());
            //}
            //catch (Exception e)
            //{
            //    Debug.WriteLine(e.ToString());
            //}

            var test = request.GetObject(new User(), "users", Instance().NewProfilUser.ToString());
            test.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as User;
                if (res != null)
                {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                        {
                            SelectedUser = res;
                        });
                    }
            });
        }
        #endregion
    }
}
