using System.Collections.Generic;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class AlbumViewModel : ViewModelBase
    {
        #region ctor

        public AlbumViewModel()
        {
            if (MyAlbum != null)
            {
                TheAlbum = MyAlbum;
                _navigationService = new NavigationService();
                ItemClickCommand = new RelayCommand(ItemClickCommandExecute);
                Charge();
            }
            //ImageAlbum = TheAlbum.image == String.Empty ? new Uri("ms-appx:///Resources/Icones/disc.png", UriKind.Absolute).ToString() : TheAlbum.image;
        }

        #endregion

        #region Attribute

        private readonly INavigationService _navigationService;

        private string _imageAlbum;

        public string ImageAlbum
        {
            get { return _imageAlbum; }
            set
            {
                _imageAlbum = value;
                RaisePropertyChanged("ImageAlbum");
            }
        }

        private List<Music> _listMusics;

        public List<Music> ListMusics
        {
            get { return _listMusics; }
            set
            {
                _listMusics = value;
                RaisePropertyChanged("ListMusics");
            }
        }

        private Album _theAlbum;

        public Album TheAlbum
        {
            get { return _theAlbum; }
            set
            {
                _theAlbum = value;
                RaisePropertyChanged("TheAlbum");
            }
        }

        public static Album MyAlbum { get; set; }

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

        private void ItemClickCommandExecute()
        {
            //PlayerControl. = TheAlbum;
            _navigationService.Navigate(new PlayerControl().GetType());
        }

        public void Charge()
        {
            var request = new HttpRequestGet();
            //try
            //{
            //    TheAlbum = (Album)await request.GetObject(new Album(), "albums", MyAlbum.id.ToString());
            //    ListMusics = TheAlbum.musics;
            //}
            //catch (Exception e)
            //{
            //    Debug.WriteLine(e.ToString());
            //}

            var album = request.GetObject(new Album(), "albums", MyAlbum.id.ToString());
            album.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as Album;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        TheAlbum = test;
                        ListMusics = TheAlbum.musics;
                    });
                }
            });
        }

        #endregion
    }
}