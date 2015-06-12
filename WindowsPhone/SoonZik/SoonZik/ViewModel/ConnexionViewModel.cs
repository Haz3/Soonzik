using System;
using System.Globalization;
using System.Net;
using Windows.ApplicationModel.Core;
using Windows.Storage;
using Windows.UI.Core;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Microsoft.Practices.ServiceLocation;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;
using Connexion = SoonZik.HttpRequest.Connexion;
using News = SoonZik.Views.News;

namespace SoonZik.ViewModel
{
    public class ConnexionViewModel : ViewModelBase
    {
        #region Attribute

        private bool _progressOn;
        public bool ProgressOn
        {
            get { return _progressOn; }
            set
            {
                _progressOn = value;
                RaisePropertyChanged("ProgressOn");
            }
        }

      

        readonly ApplicationDataContainer _localSettings = ApplicationData.Current.LocalSettings;
      
        private string _username;

        public string Username
        {
            get { return _username; }
            set
            {
                this._username = value;
                RaisePropertyChanged("Username");
            }
        }

        private string _password;

        public string Password
        {
            get { return _password; }
            set
            {
                _password = value;
                RaisePropertyChanged("Password");
            }
        }

        private RelayCommand _connexionCommand;
        public RelayCommand ConnexionCommand
        {
            get { return _connexionCommand; }
        }

        private RelayCommand _facebookTapped;
        public RelayCommand FacebookTapped
        {
            get { return _facebookTapped; }
        }
        public INavigationService Navigation;

        #endregion
        
        #region Ctor
        public ConnexionViewModel()
        {
            ProgressOn = false;
            Navigation = new NavigationService();
            _connexionCommand = new RelayCommand(MakeConnexion);
            _facebookTapped = new RelayCommand(MakeFacebookConnection);

            if (_localSettings != null && (string)_localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                _password = _localSettings.Values["SoonZikPassWord"].ToString();
                _username = _localSettings.Values["SoonZikUserName"].ToString();
            }
        }
        #endregion

        #region Method

        private async void MakeConnexion()
        {
            ProgressOn = true;
            var dispatcher = CoreApplication.MainView.CoreWindow.Dispatcher;

            await dispatcher.RunAsync(CoreDispatcherPriority.Normal, async () =>
            {
                if (_username != null && _password != null)
                {
                    var connec = new Connexion();
                    var request = (HttpWebRequest) WebRequest.Create("http://soonzikapi.herokuapp.com/login");
                    var postData = "email=" + _username + "&password=" + _password;

                    await connec.GetHttpPostResponse(request, postData);
                    var res = connec.received;
                    if (res != null)
                    {
                        try
                        {
                            var stringJson = JObject.Parse(res).SelectToken("content").ToString();
                            Singleton.Instance().CurrentUser = JsonConvert.DeserializeObject(stringJson, typeof (User)) as User;
                            ServiceLocator.Current.GetInstance<FriendViewModel>().Sources = Singleton.Instance().CurrentUser.Friends;
                            ServiceLocator.Current.GetInstance<FriendViewModel>().ItemSource = AlphaKeyGroups<User>.CreateGroups(Singleton.Instance().CurrentUser.Friends, CultureInfo.CurrentUICulture, s => s.Username, true);
                        }
                        catch (Exception e)
                        {
                            new MessageDialog("Erreur de connexion").ShowAsync();
                        }
                        WriteInformation();
                        Singleton.Instance().NewsPage = new News();
                        Navigation.Navigate(typeof(MainView));
                        ProgressOn = false;
                    }
                    else
                    {
                        new MessageDialog("Erreur de connexion Code 502").ShowAsync();
                    }
                }
                else
                {
                    new MessageDialog("Veuillez entrer vos informations de connexion").ShowAsync();
                }
            });
        }

        private void WriteInformation()
        {
            _localSettings.Values["SoonZikUserName"] = _username;
            _localSettings.Values["SoonZikPassWord"] = _password;
            _localSettings.Values["SoonZikAlreadyConnect"] = "yes";
        }

        private async void MakeFacebookConnection()
        {
            var test = "aheh";
        }
        #endregion
    }
}
