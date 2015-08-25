using System.Globalization;
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

            CultureInfo ci = new CultureInfo(Windows.System.UserProfile.GlobalizationPreferences.Languages[0]);
            if (ci.Name.Equals("en-US"))
            {
                NewsContent = SelectNews.Newstexts[1].content;
                NewsTitle = SelectNews.Newstexts[1].title;
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