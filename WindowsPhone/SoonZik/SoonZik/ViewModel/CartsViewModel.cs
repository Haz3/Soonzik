using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using GalaSoft.MvvmLight;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class CartsViewModel : ViewModelBase
    {
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

        private Music _selectedMusic;
        public Music SelectedMusic { get { return _selectedMusic; } set { _selectedMusic = value; RaisePropertyChanged("SelectedMusic"); } }
        private Album _selectedAlbum;
        public Album SelectedAlbum { get { return _selectedAlbum; } set { _selectedAlbum = value; RaisePropertyChanged("SelectedAlbum"); } }
        private Pack _selectedPack;
        public Pack SelectedPack { get { return _selectedPack; } set { _selectedPack = value; RaisePropertyChanged("SelectedPack"); } }

        public ICommand MusicTappedCommand { get; private set; }
        public ICommand PackTappedCommand { get; private set; }
        public ICommand AlbumTappedCommand { get; private set; }
        #endregion

        #region Methods

        private void Charge()
        {
            var request = new HttpRequestGet();
            var userKey = request.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                _key = task.Result as string;
                if (_key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(_key);
                    _cryptographic = EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);

                    var listCarts = request.GetItemFromCarts(new List<Carts>(), _cryptographic, Singleton.Instance().CurrentUser);

                    listCarts.ContinueWith(delegate(Task<object> tmp)
                    {
                        var res = tmp.Result as List<Carts>;
                        if (res != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                            {
                                foreach (var cart in res)
                                {
                                    if (cart.albums != null)
                                        foreach (var album in cart.albums)
                                            ListAlbum.Add(album);
                                    if (cart.musics != null)
                                        foreach (var music in cart.musics)
                                            ListMusique.Add(music);
                                    if (cart.packs != null)
                                        foreach (var pack in cart.packs)
                                            ListPack.Add(pack);
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

        private void PackTappedExecute()
        {
        }

        private void MusicTappedExecute()
        {
        }
        #endregion

        #endregion

        #region Ctor

        public CartsViewModel()
        {

            ListAlbum = new ObservableCollection<Album>();
            ListMusique = new ObservableCollection<Music>();
            ListPack = new ObservableCollection<Pack>();

            MusicTappedCommand = new RelayCommand(MusicTappedExecute);
            AlbumTappedCommand = new RelayCommand(AlbumTappedExecute);
            PackTappedCommand = new RelayCommand(PackTappedExecute);
            Charge();
        }
        #endregion
    }
}