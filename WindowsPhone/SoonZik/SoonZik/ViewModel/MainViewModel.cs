using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Media.Animation;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Ioc;
using Microsoft.Practices.ServiceLocation;
using SoonZik.Model;

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

        private RelayCommand _connexionCommand;
        public RelayCommand ConnexionCommand
        {
            get { return _connexionCommand; }
        }

        private RelayCommand _profilCommand;
        public RelayCommand ProfilCommand
        {
            get { return _profilCommand; }
        }

        private RelayCommand _newsCommand;
        public RelayCommand NewsCommand
        {
            get { return _newsCommand; }
        }

        private RelayCommand _explorerCommand;
        public RelayCommand ExplorerCommand
        {
            get { return _explorerCommand; }
        }
        
        private RelayCommand _packsCommand;
        public RelayCommand PacksCommand
        {
            get { return _packsCommand; }
        }

        private RelayCommand _mondemusicalCommand;
        public RelayCommand MondeMusicalCommand
        {
            get { return _mondemusicalCommand; }
        }

        private RelayCommand _battleCommand;
        public RelayCommand BattleCommand
        {
            get { return _battleCommand; }
        }

        private RelayCommand _playlistCommand;
        public RelayCommand PlaylistCommand
        {
            get { return _playlistCommand; }
        }

        private RelayCommand _amisCommand;
        public RelayCommand AmisCommand
        {
            get { return _amisCommand; }
        }

        private RelayCommand _achatCommand;
        public RelayCommand AchatCommand
        {
            get { return _achatCommand; }
        }
        
        private RelayCommand _menuCommand;
        public RelayCommand MenuCommand
        {
            get { return _menuCommand; }
        }

        private Pivot _myPivot;
        public RelayCommand<Pivot> GetPivotExecute { get; set; }

        private Storyboard _story;
        public RelayCommand<Storyboard> GetStoryBoardExecute { get; set; }
        
        private ToggleButton _toggleButton;
        public RelayCommand<ToggleButton> GetToggleButton { get; set; }

        private string _searchText;

        public string SearchText
        {
            get { return _searchText; }
            set
            {
                _searchText = value;
                RaisePropertyChanged("SearchText");
            }
        }
        #endregion

        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>




        #region Ctor
        public MainViewModel()
        {
            _connexionString = "Connexion";
            GetPivotExecute = new RelayCommand<Pivot>(GetPivot);
            GetStoryBoardExecute = new RelayCommand<Storyboard>(GetStory);
            GetToggleButton = new RelayCommand<ToggleButton>(GetToggle);
            _profilCommand = new RelayCommand(GoToProfil);
            _newsCommand = new RelayCommand(GoToNews);
            _explorerCommand = new RelayCommand(GoToExplorer);
            _packsCommand = new RelayCommand(GoToPacks);
            _mondemusicalCommand = new RelayCommand(GoToMondeMusical);
            _battleCommand = new RelayCommand(GoToBattle);
            _playlistCommand = new RelayCommand(GoToPlaylist);
            _amisCommand = new RelayCommand(GoToAmis);
            _achatCommand = new RelayCommand(GoToAchat);
            _connexionCommand = new RelayCommand(GoToConnexionPage);
            _menuCommand = new RelayCommand(GoToMenu);
        }


        #endregion

        #region Method

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

        private void GetPivot(Pivot obj)
        {
            if (obj != null)
                _myPivot = obj;
        }

        private void GoToProfil()
        {
            _myPivot.SelectedIndex = 1;
            CloseMenu();
        }

        private void GoToNews()
        {
            _myPivot.SelectedIndex = 0;
            CloseMenu();
        }

        private void GoToExplorer()
        {
            _myPivot.SelectedIndex = 2;
            CloseMenu();
        }

        private void GoToPacks()
        {
            _myPivot.SelectedIndex = 3;
            CloseMenu();
        }

        private void GoToMondeMusical()
        {
            _myPivot.SelectedIndex = 4;
            CloseMenu();
        }

        private void GoToBattle()
        {
            _myPivot.SelectedIndex = 5;
            CloseMenu();
        }

        private void GoToPlaylist()
        {
            _myPivot.SelectedIndex = 6;
            CloseMenu();
        }

        private void GoToAmis()
        {
            _myPivot.SelectedIndex = 7;
            CloseMenu();
        }

        private void GoToAchat()
        {
            _myPivot.SelectedIndex = 8;
            CloseMenu();
        }

        private void GoToConnexionPage()
        {
            SimpleIoc.Default.Register<MainPageViewModel>();
            ServiceLocator.Current.GetInstance<MainPageViewModel>().ConnexionVisibility = true;
            ServiceLocator.Current.GetInstance<MainPageViewModel>().PivotVisibility = false;
            _connexionString = "Deconnexion";
        }

        private void GoToMenu()
        {
            _myPivot.SelectedIndex = 9;
            CloseMenu();
        }
        #endregion
    }
}