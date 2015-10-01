using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json.Linq;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class CartsViewModel : ViewModelBase
    {
        #region Ctor

        public CartsViewModel()
        {
            LoadedCommand = new RelayCommand(Charge);

            MusicTappedCommand = new RelayCommand(MusicTappedExecute);
            AlbumTappedCommand = new RelayCommand(AlbumTappedExecute);
            DeleteCommand = new RelayCommand(DeleteCommandExecute);
        }

        #endregion

        #region Attributes

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

        private ObservableCollection<Carts> _listCarts;

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

        public ICommand MusicTappedCommand { get; private set; }
        public ICommand AlbumTappedCommand { get; private set; }
        public ICommand DeleteCommand { get; private set; }

        public ICommand LoadedCommand { get; private set; }

        #endregion

        #region Methods

        private void Charge()
        {
            ListAlbum = new ObservableCollection<Album>();
            ListMusique = new ObservableCollection<Music>();
            _listCarts = new ObservableCollection<Carts>();

            var request = new HttpRequestGet();
            var userKey = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                _key = task.Result as string;
                if (_key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(_key);
                    _cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt + stringEncrypt);

                    var listCarts = request.GetItemFromCarts(new List<Carts>(), _cryptographic,
                        Singleton.Singleton.Instance().CurrentUser);

                    listCarts.ContinueWith(delegate(Task<object> tmp)
                    {
                        var res = tmp.Result as List<Carts>;
                        if (res != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                            {
                                foreach (var cart in res)
                                {
                                    _listCarts.Add(cart);
                                    if (cart.albums != null)
                                        foreach (var album in cart.albums)
                                            ListAlbum.Add(album);
                                    if (cart.musics != null)
                                        foreach (var music in cart.musics)
                                            ListMusique.Add(music);
                                }
                            });
                        }
                    });
                }
            });
        }

        #region Method Command

        private void AlbumTappedExecute()
        {
        }

        private void MusicTappedExecute()
        {
        }

        private void DeleteCommandExecute()
        {
            var request = new HttpRequestGet();
            var userKey = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                _key = task.Result as string;
                if (_key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(_key);
                    _cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt + stringEncrypt);

                    Carts cart = null;

                    foreach (var item in _listCarts)
                    {
                        if (SelectedAlbum != null && (item.albums.Count > 0 && item.albums[0].id == SelectedAlbum.id))
                            cart = item;
                        else if (SelectedMusic != null &&
                                 (item.musics.Count > 0 && item.musics[0].id == SelectedMusic.id))
                            cart = item;
                    }

                    var resDel = request.DeleteFromCart(cart, _cryptographic, Singleton.Singleton.Instance().CurrentUser);

                    resDel.ContinueWith(delegate(Task<string> tmp)
                    {
                        var test = tmp.Result;
                        if (test != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                            {
                                var stringJson = JObject.Parse(test).SelectToken("code").ToString();
                                if (stringJson == "202")
                                {
                                    new MessageDialog("Obj delete").ShowAsync();
                                    Charge();
                                }
                                else
                                    new MessageDialog("Delete Fail code: " + stringJson).ShowAsync();
                            });
                        }
                    });
                }
            });
        }

        #endregion

        #endregion
    }
}