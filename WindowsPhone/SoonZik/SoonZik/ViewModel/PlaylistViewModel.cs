using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json.Linq;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class PlaylistViewModel : ViewModelBase
    {
        #region Ctor

        public PlaylistViewModel()
        {
            LoadedCommand = new RelayCommand(OnLoadedPageExecute);
            MoreOptionCommand = new RelayCommand(MoreOptionCommandExecute);
            UpdatePlaylist = new RelayCommand(UpdatePlaylistExecute);
            AddToPlaylist = new RelayCommand(AddToPlaylistExecute);
            DelToPlaylist = new RelayCommand(DelToPlaylistExecute);
            AddMusicToCart = new RelayCommand(AddMusicToCartExecute);
            PlayCommand = new RelayCommand(PlayCommandExecute);
        }

        #endregion

        #region Attribute

        private string _cryptographic;
        public ICommand PlayCommand { get; private set; }
        public ICommand AddToPlaylist { get; private set; }
        public ICommand DelToPlaylist { get; private set; }
        public ICommand AddMusicToCart { get; private set; }
        public ICommand LoadedCommand { get; private set; }
        public ICommand MoreOptionCommand { get; private set; }
        public static ICommand UpdatePlaylist { get; private set; }

        public static Playlist PlaylistTmp { get; set; }

        public static MessagePrompt MessagePrompt { get; set; }
        private bool _moreOption;

        private Playlist _thePlaylist;

        public Playlist ThePlaylist
        {
            get { return _thePlaylist; }
            set
            {
                _thePlaylist = value;
                RaisePropertyChanged("ThePlaylist");
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

        #endregion

        #region Method       

        private void PlayCommandExecute()
        {
            var test = 0;
        }

        private void UpdatePlaylistExecute()
        {
            var request = new HttpRequestGet();

            var res = request.GetObject(new Playlist(), "playlists", ThePlaylist.id.ToString());
            res.ContinueWith(delegate(Task<object> tmp)
            {
                var pl = tmp.Result as Playlist;
                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                    () =>
                    {
                        if (pl != null)
                            ThePlaylist = pl;
                    });
            });
        }

        private void MoreOptionCommandExecute()
        {
            _moreOption = true;
            MoreOptionPopUp.ThePlaylist = ThePlaylist;
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

        public void OnLoadedPageExecute()
        {
            ThePlaylist = PlaylistTmp;
            ListMusics = new ObservableCollection<Music>();
            UpdatePlaylistExecute();
        }

        private void AddMusicToCartExecute()
        {
            _selectedMusic = SelectedMusic;
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
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
                                                            stringEncrypt);
                }
                var res = post.SaveCart(_selectedMusic, null, _cryptographic, Singleton.Singleton.Instance().CurrentUser);
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

        private void DelToPlaylistExecute()
        {
            if (ThePlaylist != null)
            {
                _selectedMusic = SelectedMusic;
                var request = new HttpRequestGet();
                var userKey = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
                userKey.ContinueWith(delegate(Task<object> task)
                {
                    var _key = task.Result as string;
                    if (_key != null)
                    {
                        var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(_key);
                        _cryptographic =
                            EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
                                                                stringEncrypt);

                        var resDel = request.DeleteMusicFromPlaylist(ThePlaylist, _selectedMusic, _cryptographic,
                            Singleton.Singleton.Instance().CurrentUser);

                        resDel.ContinueWith(delegate(Task<string> tmp)
                        {
                            var test = tmp.Result;
                            if (test != null)
                            {
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        var stringJson = JObject.Parse(test).SelectToken("code").ToString();
                                        if (stringJson == "200")
                                        {
                                            new MessageDialog("Music delete").ShowAsync();
                                            UpdatePlaylist.Execute(null);
                                        }
                                        else
                                        {
                                            new MessageDialog("Delete Fail code: " + stringJson).ShowAsync();
                                        }
                                    });
                            }
                        });
                    }
                });
            }
            else
            {
                new MessageDialog("You need to be on the playlist").ShowAsync();
            }
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