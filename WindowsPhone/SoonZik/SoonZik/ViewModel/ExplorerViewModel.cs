using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml.Media.Imaging;
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
            ListInfluences = new ObservableCollection<Influence>();

            AlbumCommand = new RelayCommand(AlbumCommandExecute);
            TappedCommand = new RelayCommand(ArtisteTappedCommand);
            AddToPlaylist = new RelayCommand(AddToPlaylistExecute);
            AddMusicToCart = new RelayCommand(AddMusicToCartExecute);
            PlayCommand = new RelayCommand(PlayCommandExecute);
            LoadContent();
        }

        #endregion

        #region Attribute

        public ICommand AddToPlaylist { get; private set; }
        public ICommand AddMusicToCart { get; private set; }
        private string _crypto;
        public INavigationService Navigation;

        private ObservableCollection<Influence> _listInfluences;

        public ObservableCollection<Influence> ListInfluences
        {
            get { return _listInfluences; }
            set
            {
                _listInfluences = value;
                RaisePropertyChanged("ListInfluences");
            }
        }

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
        private string _cryptographic;
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
        public ICommand AlbumCommand { get; private set; }
        public ICommand PlayCommand { get; set; }

        #endregion

        #region Method

        private void AlbumCommandExecute()
        {
            AlbumViewModel.MyAlbum = SelectedMusic.album;
            GlobalMenuControl.SetChildren(new AlbumView());
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
                        });
                }
            });
            GlobalMenuControl.SetChildren(new BackgroundAudioPlayer());
        }

        public void LoadContent()
        {
            var request = new HttpRequestGet();
            try
            {
                var listGenre = request.GetListObject(new List<Influence>(), "influences");
                listGenre.ContinueWith(delegate(Task<object> tmp)
                {
                    var test = tmp.Result as List<Influence>;
                    if (test != null)
                    {
                        foreach (var item in test)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () => { ListInfluences.Add(item); });
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
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        var art = obj.Result as Artist;
                                        item.profilImage =
                                            new BitmapImage(new Uri(Constant.UrlImageUser + item.image,
                                                UriKind.RelativeOrAbsolute));
                                        if (art != null && art.artist)
                                            ListArtiste.Add(item);
                                    });
                            });
                        }
                    }
                });
                ValidateKey.GetValideKey();
                var listZik = request.GetSuggest(new List<Music>(), Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser.id.ToString());
                listZik.ContinueWith(delegate(Task<object> tmp)
                {
                    var test = tmp.Result as List<Music>;
                    if (test != null)
                    {
                        foreach (var item in test)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(
                                CoreDispatcherPriority.Normal,
                                () =>
                                {
                                    item.album.imageAlbum =
                                        new BitmapImage(new Uri(Constant.UrlImageAlbum + item.album.image,
                                            UriKind.RelativeOrAbsolute));
                                    ListMusique.Add(item);
                                });
                        }
                    }
                });
            }
            catch (Exception e)
            {
                //new MessageDialog("probleme reseau : " + e.Message).ShowAsync();
            }
        }

        private void AddMusicToCartExecute()
        {
            SelectedMusic = SelectedMusic;
            var post = new HttpRequestPost();
            ValidateKey.GetValideKey();
            var res = post.SaveCart(SelectedMusic, null, Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser);
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

        private void MusiCommandExecute()
        {
            Singleton.Singleton.Instance().SelectedMusicSingleton.Add(SelectedMusic);
            GlobalMenuControl.SetChildren(new BackgroundAudioPlayer());
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