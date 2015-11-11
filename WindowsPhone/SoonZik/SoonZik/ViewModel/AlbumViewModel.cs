﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls.Primitives;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class AlbumViewModel : ViewModelBase
    {
        #region ctor

        public AlbumViewModel()
        {
            SelectionCommand = new RelayCommand(SelectionExecute);
            SendComment = new RelayCommand(SendCommentExecute);
            AddToCart = new RelayCommand(AddToCartExecute);
            PlayCommand = new RelayCommand(PlayCommandExecute);
            AddToPlaylist = new RelayCommand(AddToPlaylistExecute);
            AddMusicToCart = new RelayCommand(AddMusicToCartExecute);
            RateMusic = new RelayCommand(RateMusicExecute);
        }

        private void RateMusicExecute()
        {
            NotationMusic.SelectMusic = SelectedMusic;
            RatePopup = new Popup();
            var content = new NotationMusic();
            width = content.Width;
            height = content.Height;
            RatePopup.Child = content;
            RatePopup.VerticalOffset = (Window.Current.Bounds.Height - height) / 2;
            RatePopup.HorizontalOffset = (Window.Current.Bounds.Width - width) / 2;
            RatePopup.IsOpen = true;
            RatePopup.Closed += RatePopupOnClosed;
        }

        private void RatePopupOnClosed(object sender, object o)
        {
            Charge();
        }

        #endregion

        #region Attribute

        public static Popup RatePopup { get; set; }

        public double width;
        public double height;

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
        public ICommand SendComment { get; private set; }
        public ICommand AddToCart { get; set; }
        public ICommand RatingValueChange { get; private set; }
        public ICommand PlayCommand { get; private set; }
        public ICommand AddToPlaylist { get; private set; }
        public ICommand AddMusicToCart { get; private set; }
        public ICommand RateMusic { get; private set; }

        private string _crypto;
        private string _cryptographic { get; set; }
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

        #endregion

        #region Method

        private void SendCommentExecute()
        {
            var post = new HttpRequestPost();
            try
            {
                ValidateKey.GetValideKey();
                var test = post.SendComment(TextComment, TheAlbum, null, Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser);
                test.ContinueWith(delegate(Task<string> tmp)
                {
                    var res = tmp.Result;
                    if (res != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            LoadComment);
                    }
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
            TheAlbum.image = Constant.UrlImageAlbum + MyAlbum.image;
            Charge();
        }

        private void AddToCartExecute()
        {
            var post = new HttpRequestPost();
            ValidateKey.GetValideKey();
            var res = post.SaveCart(null, TheAlbum, Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser);
            res.ContinueWith(delegate(Task<string> tmp2)
            {
                var res2 = tmp2.Result;
                if (res2 != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () => { new MessageDialog("Article ajoute au panier").ShowAsync(); });
                }
            });
        }

        public void Charge()
        {
            ListMusics = new ObservableCollection<Music>();
            TheAlbum = MyAlbum;
            ListMusics = TheAlbum.musics;
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

        private void PlayCommandExecute()
        {
            var request = new HttpRequestGet();
            var res = request.GetObject(new Music(), "musics", SelectedMusic.id.ToString());
            res.ContinueWith(delegate(Task<object> task)
            {
                var music = task.Result as Music;
                if (music != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            SelectedMusic = music;
                            SelectedMusic.file = "http://soonzikapi.herokuapp.com/musics/get/" + SelectedMusic.id;
                            Singleton.Singleton.Instance().SelectedMusicSingleton.Add(SelectedMusic);
                            GlobalMenuControl.SetChildren(new BackgroundAudioPlayer());
                        });
                }
            });
        }

        private void AddMusicToCartExecute()
        {
            _selectedMusic = SelectedMusic;
            var post = new HttpRequestPost();
            ValidateKey.GetValideKey();
            var res = post.SaveCart(_selectedMusic, null, Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser);
            res.ContinueWith(delegate(Task<string> tmp2)
            {
                var res2 = tmp2.Result;
                if (res2 != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () => { new MessageDialog("Article ajoute au panier").ShowAsync(); });
                }
            });
        }

        private void AddToPlaylistExecute()
        {
            MyMusicViewModel.MusicForPlaylist = SelectedMusic;
            MyMusicViewModel.IndexForPlaylist = 3;
            GlobalMenuControl.SetChildren(new MyMusic());
        }

        #endregion
    }
}