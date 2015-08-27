using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.Views;
using News = SoonZik.HttpRequest.Poco.News;

namespace SoonZik.ViewModel
{
    public class NewsViewModel : ViewModelBase
    {
        #region Ctor

        public NewsViewModel()
        {
            _listNews = new ObservableCollection<News>();
            Charge();
            ShareTapped = new RelayCommand(ShareTappedExecute);
            ItemClickCommand = new RelayCommand(ItemClickExecute);
        }

        #endregion

        #region Attribute

        public static MessagePrompt MessagePrompt { get; set; }

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

        public RelayCommand ShareTapped { get; set; }
        
        private News _selectedNews;

        public static News DetailSelectedNews { get; set; }

        public News SelectedNews
        {
            get { return _selectedNews; }
            set
            {
                _selectedNews = value;
                RaisePropertyChanged("SelectedNews");
            }
        }

        private RelayCommand _itemClickCommand;

        public RelayCommand ItemClickCommand
        {
            get { return _itemClickCommand; }
            set
            {
                _itemClickCommand = value;
                RaisePropertyChanged("ItemClickCommand");
            }
        }
        
       
        #endregion

        #region Method

        private void ItemClickExecute()
        {
            DetailSelectedNews = SelectedNews;
            GlobalMenuControl.MyGrid.Children.Clear();
            GlobalMenuControl.MyGrid.Children.Add(new NewsDetail());
        }

        private void ShareTappedExecute()
        {
            var newsBody = new NewsSharePopup(SelectedNews);
            MessagePrompt = new MessagePrompt
            {
                IsAppBarVisible = false,
                VerticalAlignment = VerticalAlignment.Center,
                Body = newsBody,
                Opacity = 0.6
            };
            MessagePrompt.ActionPopUpButtons.Clear();
            MessagePrompt.Show();
        }

        public void Charge()
        {
            var request = new HttpRequestGet();

            var listNews = request.GetListObject(new List<News>(), "news");
            listNews.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<News>;
                if (test != null)
                {
                    foreach (var item in test)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { ListNews.Add(item); });
                    }
                }
            });
        }

        #endregion
    }
}