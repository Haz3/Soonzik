using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
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
                //TheAlbum = MyAlbum;
                _navigationService = new NavigationService();
                ItemClickCommand = new RelayCommand(ItemClickCommandExecute);
                //Charge();
            }

            MoreOptionOnTapped = new RelayCommand(MoreOptionOnTappedExecute);
            SelectionCommand = new RelayCommand(SelectionExecute);
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
        private Music _selectedMusic;

        public Music SelectedMusic
        {
            get
            {
                return _selectedMusic;
            }
            set
            {
                _selectedMusic = value;
                RaisePropertyChanged("SelectedMusic");
            }
        }
        public MessagePrompt MessagePrompt { get; set; }
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
        
        public ICommand SelectionCommand { get; private set; }
        public ICommand MoreOptionOnTapped { get; set; }

        #endregion

        #region Method

        private void MoreOptionOnTappedExecute()
        {
            var newsBody = new MoreOptionPopUp(SelectedMusic);
            MessagePrompt = new MessagePrompt
            {
                Width = 300,
                Height = 450,
                IsAppBarVisible = false,
                VerticalAlignment = VerticalAlignment.Center,
                Body = newsBody,
                Opacity = 0.6
            };
            MessagePrompt.ActionPopUpButtons.Clear();
            MessagePrompt.Show();
        }


        private void SelectionExecute()
        {
            TheAlbum = MyAlbum;
            Charge();
        }

        private void ItemClickCommandExecute()
        {
            //_navigationService.Navigate(new PlayerControl().GetType());
        }

        public void Charge()
        {
            var request = new HttpRequestGet();
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