using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class NewsViewModel : ViewModelBase
    {
        #region Attribute

        public ObservableCollection<News> ListNews
        {
            get { return _listNews; }
            set
            {
                _listNews = value;
                RaisePropertyChanged("ListNews");
            }
        }

        private ObservableCollection<News> _listNews;

        #endregion

        #region Ctor

        public NewsViewModel()
        {
            var task = Task.Run(async () => await Charge());
            task.Wait();
        }

        #endregion

        #region Method

        public async Task Charge()
        {
            var request = new HttpRequestGet();
            try
            {
                var list = (List<News>) await request.GetListObject(new List<HttpRequest.Poco.News>(), "news");
                _listNews = new ObservableCollection<News>();
                foreach (var item in list)
                {
                    _listNews.Add(item);
                }
            }
            catch (Exception e)
            {
                
            }
        }
        #endregion
    }
}
