using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.Storage;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.BackgroundAudioTask;
using SoonZik.Controls;
using SoonZik.Helpers;
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
            SendComment = new RelayCommand(SendCommentExecute);
            AddToCart = new RelayCommand(AddToCartExecute);
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

        private ObservableCollection<Music> _listMusics;

        public ObservableCollection<Music> ListMusics
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
            get { return _selectedMusic; }
            set
            {
                _selectedMusic = value;
                RaisePropertyChanged("SelectedMusic");
            }
        }

        public static MessagePrompt MessagePrompt { get; set; }
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
        public ICommand SendComment { get; private set; }
        public ICommand AddToCart { get; set; }

        private string _cryptographic { get; set; }

        private bool _moreOption;

        private string _textComment;

        public string TextComment
        {
            get { return _textComment; }
            set
            {
                _textComment = value;
                RaisePropertyChanged("TextComment");
            }
        }

        private ObservableCollection<Comments> _listCommAlbum;

        public ObservableCollection<Comments> ListCommAlbum
        {
            get { return _listCommAlbum; }
            set
            {
                _listCommAlbum = value;
                RaisePropertyChanged("ListCommAlbum");
            }
        }


        private string _crypto;

        #endregion

        #region Method

        private void MoreOptionOnTappedExecute()
        {
            _moreOption = true;
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

        private void SendCommentExecute()
        {
            var request = new HttpRequestGet();
            var post = new HttpRequestPost();
            try
            {
                var userKey = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
                userKey.ContinueWith(delegate(Task<object> task)
                {
                    var key = task.Result as string;
                    if (key != null)
                    {
                        var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                        _crypto =
                            EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt + stringEncrypt);
                    }
                    var test = post.SendComment(TextComment, TheAlbum, _crypto, Singleton.Singleton.Instance().CurrentUser);
                    test.ContinueWith(delegate(Task<string> tmp)
                    {
                        var res = tmp.Result;
                        if (res != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                LoadComment);
                        }
                    });
                });
            }
            catch (Exception)
            {
                new MessageDialog("Erreur lors du post").ShowAsync();
            }
        }

        private void SelectionExecute()
        {
            TheAlbum = MyAlbum;
            Charge();
        }
        
        private void ItemClickCommandExecute()
        {
            if (!_moreOption)
            {
                Singleton.Singleton.Instance().SelectedMusicSingleton = SelectedMusic;
                LocalFolderHelper.WriteTimestamp();
                GlobalMenuControl.SetChildren(new BackgroundAudioPlayer());
            }
            //_navigationService.Navigate(new PlayerControl().GetType());
            else
                _moreOption = false;
        }

        private void AddToCartExecute()
        {
            var request = new HttpRequestGet();
            var post = new HttpRequestPost();
            _cryptographic = "";
            var userKey2 = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            userKey2.ContinueWith(delegate(Task<object> task2)
            {
                var key2 = task2.Result as string;
                if (key2 != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key2);
                    _cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt + stringEncrypt);
                }
                var res = post.SaveCart(null, TheAlbum, _cryptographic, Singleton.Singleton.Instance().CurrentUser);
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var res2 = tmp2.Result;
                    if (res2 != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { new MessageDialog("Article ajoute au panier").ShowAsync(); });
                    }
                });
            });
        }

        public void Charge()
        {
            ListMusics = new ObservableCollection<Music>();
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
                        foreach (var music in test.musics)
                        {
                            ListMusics.Add(music);
                        }
                    });
                }
            });
            LoadComment();
        }

        private void LoadComment()
        {
            TextComment = "";
            var request = new HttpRequestGet();
            ListCommAlbum = new ObservableCollection<Comments>();
            var elem = "albums/" + TheAlbum.id + "/comments";
            var listCom = request.GetListObject(new List<Comments>(), elem);
            listCom.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Comments>;
                if (res != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        foreach (var item in res)
                        {
                            ListCommAlbum.Add(item);
                        }
                    });
                }
            });
        }

        #endregion
    }
}