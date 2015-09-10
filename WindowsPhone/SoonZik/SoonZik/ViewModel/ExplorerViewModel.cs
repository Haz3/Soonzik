using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;
using Genre = SoonZik.HttpRequest.Poco.Genre;

namespace SoonZik.ViewModel
{
    public class ExplorerViewModel : ViewModelBase
    {
        #region Ctor

        public ExplorerViewModel()
        {
            Navigation = new NavigationService();
            MusiCommand = new RelayCommand(MusiCommandExecute);
            ListGenres = new ObservableCollection<Genre>();
            ListArtiste = new ObservableCollection<User>();
            ListMusique = new ObservableCollection<Music>();
            TappedCommand = new RelayCommand(ArtisteTappedCommand);
            LoadContent();
        }

        #endregion

        #region Attribute

        private string _crypto;
        public INavigationService Navigation;

        private ObservableCollection<Genre> _listGenres;

        public ObservableCollection<Genre> ListGenres
        {
            get { return _listGenres; }
            set
            {
                _listGenres = value;
                RaisePropertyChanged("ListGenres");
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

        private ObservableCollection<User> _listArtiste;

        public ObservableCollection<User> ListArtiste
        {
            get { return _listArtiste; }
            set
            {
                _listArtiste = value;
                RaisePropertyChanged("ListArtiste");
            }
        }

        public Music SelectedMusic { get; set; }
        public static Music PlayerSelectedMusic { get; set; }
        public RelayCommand MusiCommand { get; set; }

        private User _selectedArtiste;

        public User SelectedArtiste
        {
            get { return _selectedArtiste; }
            set
            {
                _selectedArtiste = value;
                RaisePropertyChanged("SelectedArtiste");
            }
        }

        public ICommand TappedCommand { get; private set; }

        #endregion

        #region Method

        public void LoadContent()
        {
            var request = new HttpRequestGet();

            var listGenre = request.GetListObject(new List<Genre>(), "genres");
            listGenre.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<Genre>;
                if (test != null)
                {
                    foreach (var item in test)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { ListGenres.Add(item); });
                    }
                }
            });
            var listUser = request.GetListObject(new List<User>(), "users");
            listUser.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<User>;
                if (test != null)
                {
                    foreach (var item in test)
                    {
                        var res = request.GetArtist(new Artist(), "users", item.id.ToString());
                        res.ContinueWith(delegate(Task<object> obj)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                            {
                                var art = obj.Result as Artist;
                                if (art != null && art.artist)
                                    ListArtiste.Add(item);
                            });
                        });
                    }
                }
            });

            var userKey = request.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                var key = task.Result as string;
                if (key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                    _crypto = EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);
                    var listZik = request.GetSuggest(new List<Music>(), _crypto,
                        Singleton.Instance().CurrentUser.id.ToString());
                    listZik.ContinueWith(delegate(Task<object> tmp)
                    {
                        var test = tmp.Result as List<Music>;
                        if (test != null)
                        {
                            foreach (var item in test)
                            {
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () => { ListMusique.Add(item); });
                            }
                        }
                    });
                }
            });
        }

        private void MusiCommandExecute()
        {
            Singleton.Instance().SelectedMusicSingleton = SelectedMusic;
            GlobalMenuControl.SetChildren(new PlayerControl());
            //Navigation.Navigate(new PlayerControl().GetType());
        }

        private void ArtisteTappedCommand()
        {
            ProfilArtisteViewModel.TheUser = SelectedArtiste;
            GlobalMenuControl.SetChildren(new ProfilArtiste());
        }

        #endregion
    }
}