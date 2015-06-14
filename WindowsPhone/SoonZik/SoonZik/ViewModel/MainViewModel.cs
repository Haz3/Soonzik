using System;
using Windows.Storage;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Media.Animation;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    /// <summary>
    /// This class contains properties that the main View can data bind to.
    /// <para>
    /// Use the <strong>mvvminpc</strong> snippet to add bindable properties to this ViewModel.
    /// </para>
    /// <para>
    /// You can also use Blend to data bind with the tool's support.
    /// </para>
    /// <para>
    /// See http://www.galasoft.ch/mvvm
    /// </para>
    /// </summary>
    public class MainViewModel : ViewModelBase
    {
        #region Attribute

        #region Attribute Command
        //private RelayCommand _connexionCommand;
        //public RelayCommand ConnexionCommand
        //{
        //    get { return _connexionCommand; }
        //}

        //private RelayCommand _profilCommand;
        //public RelayCommand ProfilCommand
        //{
        //    get { return _profilCommand; }
        //}

        //private RelayCommand _newsCommand;
        //public RelayCommand NewsCommand
        //{
        //    get { return _newsCommand; }
        //}

        //private RelayCommand _explorerCommand;
        //public RelayCommand ExplorerCommand
        //{
        //    get { return _explorerCommand; }
        //}
        
        //private RelayCommand _packsCommand;
        //public RelayCommand PacksCommand
        //{
        //    get { return _packsCommand; }
        //}

        //private RelayCommand _mondemusicalCommand;
        //public RelayCommand MondeMusicalCommand
        //{
        //    get { return _mondemusicalCommand; }
        //}

        //private RelayCommand _battleCommand;
        //public RelayCommand BattleCommand
        //{
        //    get { return _battleCommand; }
        //}

        //private RelayCommand _playlistCommand;
        //public RelayCommand PlaylistCommand
        //{
        //    get { return _playlistCommand; }
        //}

        //private RelayCommand _amisCommand;
        //public RelayCommand AmisCommand
        //{
        //    get { return _amisCommand; }
        //}

        //private RelayCommand _achatCommand;
        //public RelayCommand AchatCommand
        //{
        //    get { return _achatCommand; }
        //}
        #endregion

        readonly ApplicationDataContainer _localSettings = ApplicationData.Current.LocalSettings;
        
        private string _connexionString;
        public string ConnexionString
        {
            get { return _connexionString; }
            set
            {
                _connexionString = value;
                RaisePropertyChanged("ConnexionString");
            }
        }

        private Grid _myGlobalGrid;
        public RelayCommand<Grid> GetGridExecute { get; set; }

        private Storyboard _story;
        public RelayCommand<Storyboard> GetStoryBoardExecute { get; set; }
        
        private ToggleButton _toggleButton;
        public RelayCommand<ToggleButton> GetToggleButton { get; set; }

        private string _searchText;

        private readonly INavigationService _navigationService;

        public string SearchText
        {
            get { return _searchText; }
            set
            {
                _searchText = value;
                RaisePropertyChanged("SearchText");
            }
        }

        private Boolean _connexionVisibility;

        public Boolean ConnexionVisibility
        {
            get { return _connexionVisibility; }
            set
            {
                _connexionVisibility = value;
                RaisePropertyChanged("ConnexionVisibility");
            }
        }

        #endregion

        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>

        #region Ctor
        public MainViewModel()
        {
            //_connexionString = "Connexion";
            //this._navigationService = new NavigationService();
            //InitCommand();
        }
        
        #endregion

        #region Method

        private void InitCommand()
        {
            //GetGridExecute = new RelayCommand<Grid>(GetGrid);
            //GetStoryBoardExecute = new RelayCommand<Storyboard>(GetStory);
            //GetToggleButton = new RelayCommand<ToggleButton>(GetToggle);
            //_profilCommand = new RelayCommand(GoToProfil);
            //_newsCommand = new RelayCommand(GoToNews);
            //_explorerCommand = new RelayCommand(GoToExplorer);
            //_packsCommand = new RelayCommand(GoToPacks);
            //_mondemusicalCommand = new RelayCommand(GoToMondeMusical);
            //_battleCommand = new RelayCommand(GoToBattle);
            //_playlistCommand = new RelayCommand(GoToPlaylist);
            //_amisCommand = new RelayCommand(GoToAmis);
            //_achatCommand = new RelayCommand(GoToAchat);
            //_connexionCommand = new RelayCommand(GoToConnexionPage);
        }

        public void CloseMenu()
        {
            _story.Begin();
            _toggleButton.IsChecked = false;
        }

        private void GetToggle(ToggleButton obj)
        {
            if (obj != null)
                _toggleButton = obj;
        }

        private void GetStory(Storyboard obj)
        {
            if (obj != null)
                _story = obj;
        }

        private void GetGrid(Grid obj)
        {
            if (obj != null)
                _myGlobalGrid = obj;
        }

        private void GoToProfil()
        {
            _myGlobalGrid.Children.Clear();
            _myGlobalGrid.Children.Add(new ProfilUser());
            CloseMenu();
        }

        private void GoToNews()
        {
            _myGlobalGrid.Children.Clear();
            _myGlobalGrid.Children.Add(Singleton.Instance().NewsPage);
            CloseMenu();
        }

        private void GoToExplorer()
        {
            CloseMenu();
        }

        private void GoToPacks()
        {
            CloseMenu();
        }

        private void GoToMondeMusical()
        {
            CloseMenu();
        }

        private void GoToBattle()
        {
            CloseMenu();
        }

        private void GoToPlaylist()
        {
            CloseMenu();
        }

        private void GoToAmis()
        {
            CloseMenu();
        }

        private void GoToAchat()
        {
            CloseMenu();
        }

        private void GoToConnexionPage()
        {
            _navigationService.Navigate(typeof(Connexion));
           _connexionString = "Deconnexion";
        }

        #endregion
    }
}