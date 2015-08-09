using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class PackViewModel : ViewModelBase
    {
        private List<Album> _listAlbums;
        private Album _selectedAlbum;
        private Data _selectedData;

        public PackViewModel()
        {
            var datas = new ObservableCollection<Data>
            {
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic01.jpg", UriKind.Absolute)),
                    Title = "01"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic03.jpg", UriKind.Absolute)),
                    Title = "02"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic05.jpg", UriKind.Absolute)),
                    Title = "03"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic04.jpg", UriKind.Absolute)),
                    Title = "04"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic02.jpg", UriKind.Absolute)),
                    Title = "05"
                },
                new Data
                {
                    BitmapImage = new BitmapImage(new Uri("ms-appx:///Resources/pic06.jpg", UriKind.Absolute)),
                    Title = "06"
                }
            };

            Datas = datas;

            if (ThePack != null)
            {
                SelectionCommand = new RelayCommand(SelectionExecute);
            }
        }

        public ObservableCollection<Data> Datas { get; set; }
        public static Pack ThePack { get; set; }

        public Data SelectedData
        {
            get { return _selectedData; }
            set
            {
                _selectedData = value;
                RaisePropertyChanged("SelectedData");
            }
        }

        public Album SelectedAlbum
        {
            get { return _selectedAlbum; }
            set
            {
                _selectedAlbum = value;
                RaisePropertyChanged("SelectedAlbum");
            }
        }

        public List<Album> ListAlbums
        {
            get { return _listAlbums; }
            set
            {
                _listAlbums = value;
                RaisePropertyChanged("ListAlbums");
            }
        }

        public ICommand SelectionCommand { get; private set; }

        private void SelectionExecute()
        {
            Charge();
            ListAlbums = ThePack.albums;
        }

        public void Charge()
        {
            var request = new HttpRequestGet();
            var pack = request.GetObject(new Pack(), "packs", ThePack.id.ToString());
            pack.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as Pack;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () => { ThePack = test; });
                }
            });
        }
    }

    public class Data
    {
        public BitmapImage BitmapImage { get; set; }
        public String Title { get; set; }
    }
}