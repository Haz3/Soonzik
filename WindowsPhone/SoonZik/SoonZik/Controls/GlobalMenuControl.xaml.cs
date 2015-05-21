using System;
using Windows.UI.Xaml.Controls;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236
using GalaSoft.MvvmLight.Command;
using SoonZik.Utils;
using SoonZik.ViewModel;
using SoonZik.Views;

namespace SoonZik.Controls
{
    public sealed partial class GlobalMenuControl : UserControl
    {
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

        private readonly INavigationService _navigationService;

        public GlobalMenuControl()
        {
            this.InitializeComponent();
            this.DataContext = this;

            _myPivot = PivotControl.MyPivot;
            this._navigationService = new NavigationService();
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
            
        }

        private void GoToProfil()
        {
            _navigationService.Navigate(typeof(ProfilUser));
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
            _navigationService.Navigate(typeof(Friends));
            //_myPivot.SelectedIndex = 7;
            //CloseMenu();
        }

        private void GoToAchat()
        {
            _myPivot.SelectedIndex = 8;
            CloseMenu();
        }

        private void GoToConnexionPage()
        {
            _navigationService.Navigate(typeof(Connexion));
            //_connexionString = "Deconnexion";
        }

        private void GoToMenu()
        {
            _myPivot.SelectedIndex = 9;
            CloseMenu();
        }
    }
}
