using System.Globalization;
using Windows.System.UserProfile;
using GalaSoft.MvvmLight;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class NewsDetailViewModel : ViewModelBase
    {
        #region Ctor

        public NewsDetailViewModel()
        {
            SelectNews = NewsViewModel.DetailSelectedNews;
            var ci = new CultureInfo(GlobalizationPreferences.Languages[0]);
            if (ci.Name.Equals("en-US"))
            {
                NewsContent = SelectNews.newstexts[1].content;
                NewsTitle = SelectNews.title;
            }
            else if (ci.Name.Equals("fr-FR"))
            {
                NewsContent = SelectNews.newstexts[0].content;
                NewsTitle = SelectNews.title;
            }
        }

        #endregion

        #region Attribute

        public News SelectNews { get; set; }
        private string _newsContent;

        public string NewsContent
        {
            get { return _newsContent; }
            set
            {
                _newsContent = value;
                RaisePropertyChanged("NewsContent");
            }
        }

        private string _newsTitle;

        public string NewsTitle
        {
            get { return _newsTitle; }
            set
            {
                _newsTitle = value;
                RaisePropertyChanged("NewsTitle");
            }
        }

        #endregion

        #region Method

        #endregion
    }
}