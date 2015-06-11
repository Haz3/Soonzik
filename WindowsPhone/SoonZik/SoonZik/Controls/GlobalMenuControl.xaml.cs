using Windows.UI.Xaml.Controls;
using GalaSoft.MvvmLight.Command;
using SoonZik.Utils;
using SoonZik.Views;
// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class GlobalMenuControl : UserControl
    {
        #region Attribute


        private readonly INavigationService _navigationService;

        #endregion

        #region Ctor
        public GlobalMenuControl()
        {
            this.InitializeComponent();

            GlobalGrid.Children.Add(Singleton.Instance().NewsPage);

            this._navigationService = new NavigationService();
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
        #endregion 
        
        #region Method Menu

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

        private void GoToProfil()
        {
            GlobalGrid.Children.Clear();
            GlobalGrid.Children.Add(new ProfilUser());
            CloseMenu();
        }

        private void GoToNews()
        {
            GlobalGrid.Children.Clear();
            GlobalGrid.Children.Add(Singleton.Instance().NewsPage);
            CloseMenu();
        }

        private void GoToExplorer()
        {
            GlobalGrid.Children.Clear();
            GlobalGrid.Children.Add(new Explorer());
            CloseMenu();
        }

        private void GoToPacks()
        {
            GlobalGrid.Children.Clear();
            GlobalGrid.Children.Add(new Packs());
            CloseMenu();
        }

        private void GoToMondeMusical()
        {
            GlobalGrid.Children.Clear();
            GlobalGrid.Children.Add(new Geoloc());
            CloseMenu();
        }

        private void GoToBattle()
        {
            GlobalGrid.Children.Clear();
            GlobalGrid.Children.Add(new Battle());
            CloseMenu();
        }

        private void GoToPlaylist()
        {
            GlobalGrid.Children.Clear();
            GlobalGrid.Children.Add(new Playlist());
            CloseMenu();
        }

        private void GoToAmis()
        {
            GlobalGrid.Children.Clear();
            GlobalGrid.Children.Add(new Friends());
            CloseMenu();
        }

        private void GoToAchat()
        {
            GlobalGrid.Children.Clear();
            CloseMenu();
        }

        private void GoToConnexionPage()
        {
            _navigationService.Navigate(typeof(Connexion));
        }
    }
}
