using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;
using Playlist = SoonZik.HttpRequest.Poco.Playlist;

namespace SoonZik.ViewModel
{
    public class MyMusicViewModel : ViewModelBase
    {
        #region Ctor

        public MyMusicViewModel()
        {
            ListAlbum = new ObservableCollection<Album>();
            ListMusique = new ObservableCollection<Music>();
            ListPack = new ObservableCollection<Pack>();
            ListPlaylist = new ObservableCollection<Playlist>();

            MusicTappedCommand = new RelayCommand(MusicTappedExecute);
            AlbumTappedCommand = new RelayCommand(AlbumTappedExecute);
            PackTappedCommand = new RelayCommand(PackTappedExecute);
            PlaylistTappedCommand = new RelayCommand(PlaylistTappedExecute);

            SelectedIndex = IndexForPlaylist;

            LoadContent();
        }


        #endregion

        #region Method

        public void LoadContent()
        {
            var request = new HttpRequestGet();
            var userKey = request.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                _key = task.Result as string;
                if (_key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(_key);
                    _cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);

                    var listAlbumTmp = request.GetAllMusicForUser(new UserMusic(), _cryptographic,
                        Singleton.Instance().CurrentUser.id.ToString());

                    listAlbumTmp.ContinueWith(delegate(Task<object> tmp)
                    {
                        var test = tmp.Result as UserMusic;
                        if (test != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                            {
                                foreach (var album in test.ListAlbums)
                                    ListAlbum.Add(album);
                                foreach (var music in test.ListMusiques)
                                    ListMusique.Add(music);
                                foreach (var playlist in test.ListPack)
                                    ListPack.Add(playlist);
                            });
                        }
                    });

                    var listPlaylist = request.Find(new List<Playlist>(), "playlists", Singleton.Instance().CurrentUser.id.ToString());
                    listPlaylist.ContinueWith(delegate(Task<object> tmp)
                    {
                        var res = tmp.Result as List<Playlist>;

                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                        {
                            if (res != null)
                                foreach (var playlist in res)
                                {
                                    ListPlaylist.Add(playlist);
                                }
                        });
                    });
                }
            });
        }


        private void AlbumTappedExecute()
        {
            AlbumViewModel.MyAlbum = SelectedAlbum;
            GlobalMenuControl.SetChildren(new AlbumView());
        }

        private void PackTappedExecute()
        {
            PackViewModel.ThePack = SelectedPack;
            GlobalMenuControl.SetChildren(new Packs());
        }

        private void MusicTappedExecute()
        {
            AlbumViewModel.MyAlbum = SelectedMusic.album;
            GlobalMenuControl.SetChildren(new AlbumView());
        }

        private void PlaylistTappedExecute()
        {
            if (MusicForPlaylist == null)
            {
                PlaylistViewModel.PlaylistTmp = SelectedPlaylist;
                GlobalMenuControl.SetChildren(new PlaylistView());
            }
            else
            {
                new MessageDialog("Ajout a playlist").ShowAsync();

                SelectedPlaylist.musics.Add(MusicForPlaylist);

                var request = new HttpRequestGet();
                var post = new HttpRequestPost();
                try
                {
                    var userKey = request.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
                    userKey.ContinueWith(delegate(Task<object> task)
                    {
                        var key = task.Result as string;
                        if (key != null)
                        {
                            var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                            _crypto = EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);
                        }
                        var test = post.UpdatePlaylist(SelectedPlaylist, MusicForPlaylist, _crypto, Singleton.Instance().CurrentUser);
                        test.ContinueWith(delegate(Task<string> tmp)
                        {
                            var res = tmp.Result;
                            if (res != null)
                            {
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, RefreshPlaylist);
                            }
                        });
                    });
                }
                catch (Exception)
                {
                    new MessageDialog("Erreur update pl").ShowAsync();
                }
            }
        }

        private void RefreshPlaylist()
        {
            MusicForPlaylist = null;
        }

        #endregion

        #region Attribute

        private string _crypto { get; set; }
        public static int IndexForPlaylist { get; set; }
        private int _selectedIndex;
        public int SelectedIndex
        {
            get { return _selectedIndex;}
            set
            {
                _selectedIndex = value;
                RaisePropertyChanged("SelectedIndex");
            }
        }

        private string _key { get; set; }
        private string _cryptographic { get; set; }
        private ObservableCollection<Album> _listAlbum;
        public ObservableCollection<Album> ListAlbum
        {
            get { return _listAlbum; }
            set
            {
                _listAlbum = value;
                RaisePropertyChanged("ListAlbum");
            }
        }
        private ObservableCollection<Music> _listMusique;
        public ObservableCollection<Music> ListMusique
        {
            get { return _listMusique; }
            set
            {
                _listMusique = value;
                RaisePropertyChanged("ListMusique");
            }
        }
        private ObservableCollection<Pack> _listPack;
        public ObservableCollection<Pack> ListPack
        {
            get { return _listPack; }
            set
            {
                _listPack = value;
                RaisePropertyChanged("ListPack");
            }
        }
        private ObservableCollection<Playlist> _listPlaylist;
        public ObservableCollection<Playlist> ListPlaylist
        {
            get { return _listPlaylist; }
            set
            {
                _listPlaylist = value;
                RaisePropertyChanged("ListPlaylist");
            }
        }

        private Music _selectedMusic;
        public Music SelectedMusic { get {return _selectedMusic;} set { _selectedMusic = value;RaisePropertyChanged("SelectedMusic"); } }
        private Album _selectedAlbum;
        public Album SelectedAlbum { get { return _selectedAlbum; } set { _selectedAlbum = value; RaisePropertyChanged("SelectedAlbum"); } }
        private Pack _selectedPack;
        public Pack SelectedPack { get { return _selectedPack; } set { _selectedPack = value;RaisePropertyChanged("SelectedPack"); } }
        private Playlist _selectedPlaylist;
        public Playlist SelectedPlaylist { get { return _selectedPlaylist; } set { _selectedPlaylist = value;RaisePropertyChanged("SelectedPlaylist"); } }

        public ICommand MusicTappedCommand { get; private set; }
        public ICommand PackTappedCommand { get; private set; }
        public ICommand AlbumTappedCommand { get; private set; }
        public ICommand PlaylistTappedCommand { get; private set; }

        public static Music MusicForPlaylist;

        #endregion
    }
}