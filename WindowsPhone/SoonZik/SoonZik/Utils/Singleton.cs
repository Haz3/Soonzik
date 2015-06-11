using SoonZik.HttpRequest.Poco;
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

        public News NewsPage { get; set; }

        #endregion

        #region Ctor
        protected internal Singleton()
        {

        }
        #endregion
    }
}
