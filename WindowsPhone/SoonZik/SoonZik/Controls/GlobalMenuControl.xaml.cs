using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using Windows.Devices.Geolocation;
using Windows.Phone.UI.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media.Animation;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Properties;
using SoonZik.Utils;
using SoonZik.ViewModel;
using SoonZik.Views;
using Battle = SoonZik.Views.BattleView;
using News = SoonZik.Views.News;
using Playlist = SoonZik.Views.MyMusic;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class GlobalMenuControl : UserControl, INotifyPropertyChanged
    {
        #region NotifyPropertyCahnge

        [NotifyPropertyChangedInvocator]
        private void RaisePropertyChange(string propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }

        #endregion

        #region Attribute

        public static Grid MyGrid { get; set; }
        public ObservableCollection<SearchResult> ListObject;
        public event PropertyChangedEventHandler PropertyChanged;
        public string SearchText { get; set; }
        private readonly INavigationService _navigationService;
        private static UIElement _lastElement;

        #endregion

        #region Attributes StoryBoard Menu

        private static Storyboard story { get; set; }
        private static ToggleButton toggle { get; set; }
        public static ToggleButton MenuToggleButton { get; set; }

        #endregion

        #region Attributes Recherche

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

        private User _selectedUser;

        private User _selectedArtist;

        public User SelectedArtist
        {
            get { return _selectedArtist; }
            set
            {
                _selectedArtist = value;
                RaisePropertyChange("SelectedArtist");
            }
        }

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

        #endregion

        #region Attribute Headers

        private string _headerArtiste;

        public string HeaderArtiste
        {
            get { return _headerArtiste; }
            set
            {
                _headerArtiste = value;
                RaisePropertyChange("HeaderArtiste");
            }
        }

        private string _headerMusique;

        public string HeaderMusique
        {
            get { return _headerMusique; }
            set
            {
                _headerMusique = value;
                RaisePropertyChange("HeaderMusique");
            }
        }

        private string _headerUser;

        public string HeaderUser
        {
            get { return _headerUser; }
            set
            {
                _headerUser = value;
                RaisePropertyChange("Header");
            }
        }

        private string _headerPack;

        public string HeaderPack
        {
            get { return _headerPack; }
            set
            {
                _headerPack = value;
                RaisePropertyChange("HeaderPack");
            }
        }

        private string _headerAlbum;

        public string HeaderAlbum
        {
            get { return _headerAlbum; }
            set
            {
                _headerAlbum = value;
                RaisePropertyChange("HeaderAlbum");
            }
        }

        #endregion

        #region Ctor

        public GlobalMenuControl()
        {
            InitializeComponent();
            DataContext = this;
            MyGrid = GlobalGrid;
            GlobalGrid.Children.Add(new News());

            _navigationService = new NavigationService();
            HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;

            story = MenuStoryBoardBack;
            toggle = ToggleButtonSearch;
            MenuToggleButton = ToggleButtonMenu;
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleStyle"] as Style;

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
            APropos.Command = new RelayCommand(GoToAbout);
        }

        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs e)
        {
            e.Handled = true;
            SetChildren(_lastElement);
        }

        #endregion

        #region Method Menu

        private void MenuAloneClose_OnCompleted(object sender, object e)
        {
            ToggleButtonMenu.IsChecked = false;
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleStyle"] as Style;
            MenuStoryBoardBack.Pause();
        }

        private void SearchAloneBack_OnCompleted(object sender, object e)
        {
            ToggleButtonSearch.IsChecked = false;
            SearchStoryBoardBack.Pause();
        }

        public static void CloseMenu()
        {
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleStyle"] as Style;
            story.Begin();
            toggle.IsChecked = false;
        }

        #endregion

        #region Method Bouttons

        private void GoToProfil()
        {
            MenuNameTextBlock.Text = "Profil";
            Singleton.Singleton.Instance().ItsMe = true;
            SetChildren(new ProfilUser());
        }

        private void GoToNews()
        {
            SetChildren(new News());
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
            var locator = new Geolocator();
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
            //PlaylistAdd.Visibility = Visibility.Visible;
            SetChildren(new Playlist());
        }

        private void GoToAmis()
        {
            SetChildren(new MyNetwork());
        }

        private void GoToAbout()
        {
            SetChildren(new AboutView());
        }

        private void GoToAchat()
        {
            SetChildren(new CartsView());
        }

        private void GoToConnexionPage()
        {
            _navigationService.Navigate(typeof (Connexion));
        }

        public static void SetChildren(UIElement myObj)
        {
            //if (myObj.GetType() != typeof(Playlist))
            // PlaylistAdd.Visibility = Visibility.Collapsed;
            Singleton.Singleton.Instance().LastElement = MyGrid.Children.First();
            _lastElement = MyGrid.Children.LastOrDefault();
            MyGrid.Children.Clear();
            MyGrid.Children.Add(myObj);
            CloseMenu();
        }

        #endregion

        #region Methods Search

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
                var list = (SearchResult) await request.Search(new SearchResult(), SearchText);
                if (list != null)
                {
                    MyResult = list;
                    DisplayResult();
                }
            }

            catch (Exception e)
            {
                Debug.WriteLine(e.Message);
            }
        }

        private void DisplayResult()
        {
            if (MyResult.artist != null)
            {
                ResultArtisteListView.Visibility = Visibility.Visible;
                ResultArtisteListView.ItemsSource = MyResult.artist;
            }
            if (MyResult.user != null)
            {
                ResultUserListView.Visibility = Visibility.Visible;
                ResultUserListView.ItemsSource = MyResult.user;
            }
            if (MyResult.album != null)
            {
                ResultAlbumListView.Visibility = Visibility.Visible;
                ResultAlbumListView.ItemsSource = MyResult.album;
            }
            if (MyResult.pack != null)
            {
                ResultPackListView.Visibility = Visibility.Visible;
                ResultPackListView.ItemsSource = MyResult.pack;
            }
            if (MyResult.music != null)
            {
                ResultMusicListView.Visibility = Visibility.Visible;
                ResultMusicListView.ItemsSource = MyResult.music;
            }
        }

        private void CleanResultList()
        {
            //ResultArtisteListView.ItemsSource = null;
            //ResultUserListView.ItemsSource = null;
            //ResultAlbumListView.ItemsSource = null;
            //ResultMusicListView.ItemsSource = null;
            //ResultPackListView.ItemsSource = null;
        }

        private void GlobalGrid_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            CloseMenu();
            ToggleButtonMenu.Style = Application.Current.Resources["MenuToggleStyle"] as Style;
        }

        private void UsersStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            ProfilFriendViewModel.UserFromButton = SelectedUser;
            SetChildren(new ProfilFriendView());
        }

        private void MusicStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            AlbumViewModel.MyAlbum = SelectedMusic.album;
            SetChildren(new AlbumView());
        }

        private void AlbumStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            AlbumViewModel.MyAlbum = SelectedAlbum;
            SetChildren(new AlbumView());
        }

        private void ArtistStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            ProfilArtisteViewModel.TheUser = SelectedArtist;
            SetChildren(new ProfilArtiste());
        }

        private void PackStackPanel_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            PackViewModel.ThePack = SelectedPack;
            SetChildren(new Packs());
        }

        #endregion

        #region Method Toggle

        private void ToggleButtonMenu_OnChecked(object sender, RoutedEventArgs e)
        {
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleCloseStyle"] as Style;
        }

        private void ToggleButtonMenu_OnUnchecked(object sender, RoutedEventArgs e)
        {
            MenuToggleButton.Style = Application.Current.Resources["MenuToggleStyle"] as Style;
        }

        #endregion
    }
}