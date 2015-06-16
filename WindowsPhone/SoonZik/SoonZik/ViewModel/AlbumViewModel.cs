using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;
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
        #region Attribute

        private INavigationService _navigationService;

        private string _imageAlbum;
        public string ImageAlbum
        {
            get { return _imageAlbum;}
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
            get { return _theAlbum;}
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

        #region ctor

        public AlbumViewModel()
        {
            if (MyAlbum != null)
            {
                TheAlbum = MyAlbum;
                _navigationService = new NavigationService();
                ItemClickCommand = new RelayCommand(ItemClickCommandExecute); 
                var task = Task.Run(async () => await Charge());
                task.Wait();
            }
            //ImageAlbum = TheAlbum.image == String.Empty ? new Uri("ms-appx:///Resources/Icones/disc.png", UriKind.Absolute).ToString() : TheAlbum.image;

        }
        #endregion

        #region Method
        private void ItemClickCommandExecute()
        {
            //PlayerControl. = TheAlbum;
            _navigationService.Navigate(new PlayerControl().GetType());
        }

        public async Task Charge()
        {
            var request = new HttpRequestGet();
            try
            {
                TheAlbum = (Album)await request.GetObject(new Album(), "albums", MyAlbum.id.ToString());
                ListMusics = TheAlbum.musics;
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }
        #endregion


    }
}
