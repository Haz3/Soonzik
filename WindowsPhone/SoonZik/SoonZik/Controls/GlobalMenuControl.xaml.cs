using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Windows.Devices.Geolocation;
using Windows.Phone.UI.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight.Command;
using SoonZik.Annotations;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.ViewModel;
using SoonZik.Views;
using Battle = SoonZik.Views.BattleView;
using Connexion = SoonZik.Views.Connexion;
using News = SoonZik.Views.News;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class GlobalMenuControl : UserControl, INotifyPropertyChanged
    {
        #region Attribute

        public static Grid MyGrid { get; set; }

        private SearchResult _myResult;

        public SearchResult MyResult
        {
            get { return _myResult; }
            set
            {
                _myResult = value;
                RaisePropertyChange("MyResult");
            }
        }

        public ObservableCollection<SearchResult> ListObject;

        public event PropertyChangedEventHandler PropertyChanged;
        public string SearchText { get; set; }
        private readonly INavigationService _navigationService;

        private UIElement _lastElement;

        private User _selectedUser;
        public User SelectedUser
        {
            get { return _selectedUser; }
            set
            {
                _selectedUser = value;
                RaisePropertyChange("SelectedUser");
            }
        }
        private Music _selectedMusic;
        public Music SelectedMusic
        {
            get { return _selectedMusic; }
            set
            {
                _selectedMusic = value;
                RaisePropertyChange("SelectedMusic");
            }
        }
        private Album _selectedAlbum;
        public Album SelectedAlbum
        {
            get { return _selectedAlbum; }
            set
            {
                _selectedAlbum = value;
                RaisePropertyChange("SelectedAlbum");
            }
        }
        private Pack _selectedPack;
        public Pack SelectedPack
        {
            get { return _selectedPack; }
            set
            {
                _selectedPack = value;
                RaisePropertyChange("SelectedPack");
            }
        }
        private BouttonMenu _selectedBouttonMenu;
        public BouttonMenu SelectedBouttonMenu
        {
            get { return _selectedBouttonMenu; }
            set
            {
                _selectedBouttonMenu = value;
                RaisePropertyChange("SelectedBouttonMenu");
            }
        }
        public List<BouttonMenu> ListBouttonMenus { get; set; }
        #endregion

        #region Ctor

        public GlobalMenuControl()
        {
            this.InitializeComponent();
            this.DataContext = this;
            MyGrid = GlobalGrid;
            GlobalGrid.Children.Add(Singleton.Instance().NewsPage);

            this._navigationService = new NavigationService();

            HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;

            //InitList();
            //MenuListView.ItemsSource = ListBouttonMenus;

            ProfilButton.Command = new RelayCommand(GoToProfil);
            NewsButton.Command = new RelayCommand(GoToNews);
            ExplorerButton.Command = new RelayCommand(GoToExplorer);
            PacksButton.Command = new RelayCommand(GoToPacks);
            MondeMusicalButton.Command = new RelayCommand(GoToMondeMusical);
            BattleButton.Command = new RelayCommand(GoToBattle);
            PlaylistButton.Command = new RelayCommand(GoToPlaylist);
            AmisButton.Command = new RelayCommand(GoToAmis);
            AchatButton.Command = new RelayCommand(GoToAchat);
            ConnexionButton.Command = new RelayCommand(GoToConnexionPage);
        }

        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs e)
        {
            e.Handled = true;
            SetChildren(_lastElement);
        }

        #endregion

        #region Method Menu

        private void InitList()
        {
            ListBouttonMenus = new List<BouttonMenu>
            {
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/ProfilMenu.png", UriKind.Absolute)),
                    Title = Singleton.Instance().CurrentUser.username,
                    PageBoutton = typeof(ProfilUser)
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuNews.png", UriKind.Absolute)),
                    Title = "News",
                    PageBoutton = typeof(ProfilUser)
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuExplorer.png", UriKind.Absolute)),
                    Title = "Explorer",
                    PageBoutton = typeof(ProfilUser)
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuPack.png", UriKind.Absolute)),
                    Title = "Packs",
                    PageBoutton = typeof(ProfilUser)
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuMondeMusical.png", UriKind.Absolute)),
                    Title = "Monde Musical",
                    PageBoutton = typeof(ProfilUser)
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuBattle.png", UriKind.Absolute)),
                    Title = "Battle",
                    PageBoutton = typeof(ProfilUser)
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuPlaylist.png", UriKind.Absolute)),
                    Title = "Playlist",
                    PageBoutton = typeof(ProfilUser)
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuFriend.png", UriKind.Absolute)),
                    Title = "Amis",
                    PageBoutton = typeof(ProfilUser)
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuAchat.png", UriKind.Absolute)),
                    Title = "Achat",
                    PageBoutton = null
                },
                new BouttonMenu()
                {
                    ImageBoutton = new BitmapImage(new Uri("ms-appx:///Resources/Icones/MenuDeco.png", UriKind.Absolute)),
                    Title = "Connexion",
                    PageBoutton = typeof(ProfilUser)
                },
            };
        }

        private void GridItemMenu_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            if (SelectedBouttonMenu.PageBoutton.Equals(new ProfilUser()))
            {
                Singleton.Instance().ItsMe = true;
                Singleton.Instance().ProfilPage = new ProfilUser();
                SetChildren(Singleton.Instance().ProfilPage);
            }
            else if (SelectedBouttonMenu.PageBoutton.Equals(new News()))
                SetChildren(Singleton.Instance().NewsPage);
            else if (SelectedBouttonMenu.PageBoutton.Equals(new GeolocalisationView()))
            {
                var locator = new Geolocator();
                if (locator.LocationStatus == PositionStatus.Disabled)
                    new MessageDialog("Veuillez activer votre Location").ShowAsync();
                else
                    SetChildren(new GeolocalisationView());
            }
            else if (SelectedBouttonMenu.PageBoutton.Equals(new Connexion()))
                _navigationService.Navigate(typeof (Connexion));
            else
            {
                var obj = SelectedBouttonMenu.PageBoutton as UIElement;
                
                SetChildren(obj);
            }
        }

        private void MenuAloneClose_OnCompleted(object sender, object e)
        {
            ToggleButtonMenu.IsChecked = false;
            MenuStoryBoardBack.Pause();
        }

        private void SearchAloneBack_OnCompleted(object sender, object e)
        {
            ToggleButtonSearch.IsChecked = false;
            SearchStoryBoardBack.Pause();
        }

        public void CloseMenu()
        {
            MenuStoryBoardBack.Begin();
            ToggleButtonSearch.IsChecked = false;
        }

        #endregion

        #region Method Bouttons
        private void GoToProfil()
        {
            Singleton.Instance().ItsMe = true;
            Singleton.Instance().ProfilPage = new ProfilUser();
            SetChildren(Singleton.Instance().ProfilPage);
        }

        private void GoToNews()
        {
            SetChildren(Singleton.Instance().NewsPage);
        }

        private void GoToExplorer()
        {
            SetChildren(new Explorer());
        }

        private void GoToPacks()
        {
            SetChildren(new Packs());
        }

        private void GoToMondeMusical()
        {
            Geolocator locator = new Geolocator();
            if (locator.LocationStatus == PositionStatus.Disabled)
            {
                new MessageDialog("Veuillez activer votre Location").ShowAsync();
            }
            else
            {
                SetChildren(new GeolocalisationView());
            }
        }

        private void GoToBattle()
        {
            SetChildren(new BattleView());
        }

        private void GoToPlaylist()
        {
           SetChildren(new Playlist());
        }

        private void GoToAmis()
        {
            SetChildren(new Friends());
        }

        private void SetChildren(UIElement myObj)
        {
            Singleton.Instance().LastElement = MyGrid.Children.First();
            _lastElement = MyGrid.Children.FirstOrDefault();
            MyGrid.Children.Clear();
            MyGrid.Children.Add(myObj);
            CloseMenu();
        }

        private void GoToAchat()
        {
            MyGrid.Children.Clear();
            CloseMenu();
        }

        private void GoToConnexionPage()
        {
            _navigationService.Navigate(typeof(Connexion));
        }

        #endregion

        #region Methods
        private void SearchTextBlock_OnTextChanged(object sender, TextChangedEventArgs e)
        {
            SearchText = SearchTextBlock.Text;
            if (SearchText != string.Empty)
                MakeTheSearch();
            else
                CleanResultList();
        }

        private async void MakeTheSearch()
        {
            var request = new HttpRequestGet();
            try
            {
                var list = (SearchResult)await request.Search(new SearchResult(), SearchText);
                if (list != null)
                {
                    MyResult = list;
                    ResultArtisteListView.ItemsSource = MyResult.artist;
                    ResultUserListView.ItemsSource = MyResult.user;
                    ResultAlbumListView.ItemsSource = MyResult.album;
                    ResultMusicListView.ItemsSource = MyResult.music;
                    ResultPackListView.ItemsSource = MyResult.pack;
                }
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.Message);
            }
        }

        private void CleanResultList()
        {
            ResultArtisteListView.ItemsSource = null;
            ResultUserListView.ItemsSource = null;
            ResultAlbumListView.ItemsSource = null;
            ResultMusicListView.ItemsSource = null;
            ResultPackListView.ItemsSource = null;
        }

        private void GlobalGrid_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            CloseMenu();
        }

        private void UsersStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            Singleton.Instance().NewProfilUser = SelectedUser.id;
            Singleton.Instance().ItsMe = false;
            var task = Task.Run(async () => await Singleton.Instance().Charge());
            task.Wait();
            MyGrid.Children.Clear();
            MyGrid.Children.Add(new ProfilFriendView());
            CloseMenu();
        }

        private void MusicStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            Singleton.Instance().SelectedMusicSingleton = SelectedMusic;
            _navigationService.Navigate(new PlayerControl().GetType());
            CloseMenu();
        }
        #endregion


        private void AlbumStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            AlbumViewModel.MyAlbum = SelectedAlbum;
            SetChildren(new AlbumView());
        }

        private void ArtistStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            ProfilArtisteViewModel.TheUser = SelectedUser;
            SetChildren(new ProfilArtiste());
        }

        private void PackStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            PackViewModel.ThePack = SelectedPack;
            SetChildren(new Packs());
        }

        #region NotifyPropertyCahnge
        [NotifyPropertyChangedInvocator]
        private void RaisePropertyChange(string propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }
        #endregion
    }
}