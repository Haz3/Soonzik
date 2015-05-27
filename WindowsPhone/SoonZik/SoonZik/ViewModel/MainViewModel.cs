using System;
using System.Diagnostics;
using System.Net;
using System.Threading.Tasks;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Media.Animation;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;
using NavigationService = SoonZik.Utils.NavigationService;

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

        readonly Windows.Storage.ApplicationDataContainer _localSettings = Windows.Storage.ApplicationData.Current.LocalSettings;
        
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
        
        private Pivot _myPivot;
        public RelayCommand<Pivot> GetPivotExecute { get; set; }

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

        #endregion

        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>

        #region Ctor
        public MainViewModel()
        {
            Debug.WriteLine("----------------------" + (string)_localSettings.Values["SoonZikAlreadyConnect"]);

            _connexionString = "Connexion";

            this._navigationService = new NavigationService();

            InitCommand();
            if (_localSettings != null && (string)_localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                Task task = Task.Run(async () => await DirectConnect());
                task.Wait();
            }
        }
        
        #endregion

        #region Method

        private void InitCommand()
        {
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
        }

        private async Task<User> DirectConnect()
        {
            var connec = new HttpRequest.Connexion();
            var request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/login");
            var postData = "email=" + _localSettings.Values["SoonZikUserName"] + "&password=" + _localSettings.Values["SoonZikPassWord"];

            await connec.GetHttpPostResponse(request, postData);
            var res = connec.received;
            if (res != null)
            {
                try
                {
                    var stringJson = JObject.Parse(res).SelectToken("content").ToString();
                    var resultat = JsonConvert.DeserializeObject(stringJson, typeof(User)) as User;
                    Singleton.Instance().CurrentUser = resultat;
                    return resultat;
                }
                catch (Exception e)
                {
                }
                //ServiceLocator.Current.GetInstance<FriendViewModel>().Sources = Singleton.Instance().CurrentUser.Friends;
            }
            return null;
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

        private void GetPivot(Pivot obj)
        {
            if (obj != null)
                _myPivot = obj;
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
            _myPivot.SelectedIndex = 1;
            CloseMenu();
        }

        private void GoToPacks()
        {
            _myPivot.SelectedIndex = 2;
            CloseMenu();
        }

        private void GoToMondeMusical()
        {
            _myPivot.SelectedIndex = 3;
            CloseMenu();
        }

        private void GoToBattle()
        {
            _myPivot.SelectedIndex = 4;
            CloseMenu();
        }

        private void GoToPlaylist()
        {
            _myPivot.SelectedIndex = 5;
            CloseMenu();
        }

        private void GoToAmis()
        {
            //_navigationService.Navigate(typeof(Friends));
            _myPivot.SelectedIndex = 6;
            CloseMenu();
        }

        private void GoToAchat()
        {
            _myPivot.SelectedIndex = 7;
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