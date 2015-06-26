using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
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
        public ObservableCollection<Data> Datas { get; set; }

        public static Pack ThePack { get; set; }

        private Data _selectedData;

        public Data SelectedData
        {
            get { return _selectedData;}
            set
            {
                _selectedData = value; 
                RaisePropertyChanged("SelectedData");
            }
        }

        private Album _selectedAlbum;

        public Album SelectedAlbum
        {
            get { return _selectedAlbum; }
            set
            {
                _selectedAlbum = value;
                RaisePropertyChanged("SelectedAlbum");
            }
        }

        private List<Album> _listAlbums;

        public List<Album> ListAlbums
        {
            get { return _listAlbums;}
            set
            {
                _listAlbums = value;
                RaisePropertyChanged("ListAlbums");
            }
        }

        private ICommand _selectionCommand;
        public ICommand SelectionCommand
        {
            get { return _selectionCommand; }
        }

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
            
            this.Datas = datas;

            if (ThePack != null)
            {
                _selectionCommand = new RelayCommand(SelectionExecute);
            }

        }

        private void SelectionExecute()
        {
            Charge();
            ListAlbums = ThePack.Albums;
        }

        public void Charge()
        {
            var request = new HttpRequestGet();
            //try
            //{
            //    ThePack = (Pack)await request.GetObject(new Pack(), "packs", ThePack.Id.ToString());
            //}
            //catch (Exception e)
            //{
            //    Debug.WriteLine(e.ToString());
            //}

            var pack = request.GetObject(new Pack(), "packs", ThePack.Id.ToString());
            pack.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as Pack;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        ThePack = test;
                    });
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
