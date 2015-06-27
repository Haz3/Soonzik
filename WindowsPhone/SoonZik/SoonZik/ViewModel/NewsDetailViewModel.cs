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
        }

        #endregion

        #region Attribute

        public News SelectNews { get; set; }

        #endregion

        #region Method

        #endregion
    }
}