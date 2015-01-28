using Windows.UI.Popups;
using Windows.UI.Xaml.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
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
        public RelayCommand PlayslistCommand
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

        private Pivot _myPivot;
        public RelayCommand<Pivot> GetPivotExecute { get; set; }
        #endregion

        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>




        #region Ctor
        public MainViewModel()
        {
            _connexionString = "Connexion";
            GetPivotExecute = new RelayCommand<Pivot>(GetPivot);    
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

        }
        #endregion

        #region Method

        private void GetPivot(Pivot obj)
        {
            if (obj != null)
                _myPivot = obj;
        }

        private void GoToProfil()
        {
            _myPivot.SelectedIndex = 1;
        }

        private void GoToNews()
        {
            _myPivot.SelectedIndex = 2;
        }

        private void GoToExplorer()
        {
            _myPivot.SelectedIndex = 3;
        }

        private void GoToPacks()
        {
            _myPivot.SelectedIndex = 4;
        }

        private void GoToMondeMusical()
        {
            _myPivot.SelectedIndex = 5;
        }

        private void GoToBattle()
        {
            _myPivot.SelectedIndex = 6;
        }

        private void GoToPlaylist()
        {
            _myPivot.SelectedIndex = 7;
        }

        private void GoToAmis()
        {
            _myPivot.SelectedIndex = 8;
        }

        private void GoToAchat()
        {
            _myPivot.SelectedIndex = 9;
        }

        private void GoToConnexionPage()
        {
            var test = new MessageDialog("Go to Connexion");
            _connexionString = "Deconexion";
        }
        #endregion
    }
}