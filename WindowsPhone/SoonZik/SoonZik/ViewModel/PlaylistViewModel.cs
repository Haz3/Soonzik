using System.Collections.ObjectModel;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using GalaSoft.MvvmLight;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class PlaylistViewModel : ViewModelBase
    {
        #region Ctor

        public PlaylistViewModel()
        {
            ListAlbum = new ObservableCollection<Album>();
            ListMusique = new ObservableCollection<Music>();
            ListPlaylist = new ObservableCollection<Playlist>();
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
                                foreach (var playlist in test.ListPlaylists)
                                    ListPlaylist.Add(playlist);
                            });
                        }
                    });
                }
            });
        }

        #endregion

        #region Attribute

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

        public Music SelectedMusic { get; set; }
        public Album SelectedAlbum { get; set; }
        public Playlist SelectedPlaylist { get; set; }

        #endregion
    }
}