using System;
using System.Globalization;
using System.Windows.Input;
using Windows.ApplicationModel.Activation;
using Windows.ApplicationModel.Core;
using Windows.Storage;
using Windows.UI.Core;
using Windows.UI.Popups;
using Facebook;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Microsoft.Practices.ServiceLocation;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;
using News = SoonZik.Views.News;

namespace SoonZik.ViewModel
{
    public class ConnexionViewModel : ViewModelBase, IWebAuthenticationBrokerContinuable
    {
        #region Attribute

        private FaceBookHelper ObjFBHelper = new FaceBookHelper();
        private FacebookClient fbclient = new FacebookClient();

        private ICommand _selectionCommand;

        public ICommand SelectionCommand
        {
            get { return _selectionCommand; }
        }

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



        private readonly ApplicationDataContainer _localSettings = ApplicationData.Current.LocalSettings;

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

        private RelayCommand _inscriptionCommand;

        public RelayCommand InscritpiomCommand
        {
            get { return _inscriptionCommand; }
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
            _selectionCommand = new RelayCommand(SelectionExecute);
            _inscriptionCommand = new RelayCommand(ExecuteInscription);
            if (_localSettings != null && (string) _localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                _password = _localSettings.Values["SoonZikPassWord"].ToString();
                _username = _localSettings.Values["SoonZikUserName"].ToString();
            }
        }

        private void ExecuteInscription()
        {
            Navigation.Navigate(new InscriptionView().GetType());
        }

        #endregion

        #region Method

        private void SelectionExecute()
        {
            //if (_localSettings != null && (string)_localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            //{
            //    _password = _localSettings.Values["SoonZikPassWord"].ToString();
            //    _username = _localSettings.Values["SoonZikUserName"].ToString();
            //    MakeConnexion();
            //}
        }

        private async void MakeConnexion()
        {
            ProgressOn = true;
            var dispatcher = CoreApplication.MainView.CoreWindow.Dispatcher;

            await dispatcher.RunAsync(CoreDispatcherPriority.Normal, async () =>
            {
                if (_username != string.Empty && _password != string.Empty)
                {
                    var connec = new HttpRequestPost();
                    await connec.ConnexionSimple(_username, _password);
                    var res = connec.Received;
                    GetUser(res);
                }
                else
                {
                    new MessageDialog("Veuillez entrer vos informations de connexion").ShowAsync();
                }
            });
        }

        private void GetUser(string res)
        {
            if (res != null)
            {
                try
                {
                    var stringJson = JObject.Parse(res).SelectToken("content").ToString();
                    Singleton.Instance().CurrentUser = JsonConvert.DeserializeObject(stringJson, typeof (User)) as User;
                    ServiceLocator.Current.GetInstance<FriendViewModel>().Sources = Singleton.Instance().CurrentUser.friends;
                    ServiceLocator.Current.GetInstance<FriendViewModel>().ItemSource = AlphaKeyGroups<User>.CreateGroups(Singleton.Instance().CurrentUser.friends, CultureInfo.CurrentUICulture,
                            s => s.username, true);
                }
                catch (Exception e)
                {
                    new MessageDialog("Erreur de connexion" + e.ToString()).ShowAsync();
                }
                WriteInformation();
                Singleton.Instance().NewsPage = new News();
                Navigation.Navigate(typeof (MainView));
                ProgressOn = false;
            }
            else
            {
                new MessageDialog("Erreur de connexion Code 502").ShowAsync();
            }
        }

        private void WriteInformation()
        {
            _localSettings.Values["SoonZikUserName"] = _username;
            _localSettings.Values["SoonZikPassWord"] = _password;
            _localSettings.Values["SoonZikAlreadyConnect"] = "yes";
        }

        private async void MakeFacebookConnection()
        {
            ObjFBHelper.LoginAndContinue();
        }

        public async void ContinueWithWebAuthenticationBroker(WebAuthenticationBrokerContinuationEventArgs args)
        {
            ObjFBHelper.ContinueAuthentication(args);
            if (ObjFBHelper.AccessToken != null)
            {
                ProgressOn = true;
                fbclient = new FacebookClient(ObjFBHelper.AccessToken);
                Singleton.Instance().MyFacebookClient = new FacebookClient(ObjFBHelper.AccessToken);

                dynamic result = await fbclient.GetTaskAsync("me");
                string id = result.id;

                var connecionSocial = new HttpRequestPost();
                var getKey = new HttpRequestGet();

                string key = await getKey.GetSocialToken(id, "facebook") as string;
                char[] delimiter = {' ', '"', '{', '}'};
                string[] word = key.Split(delimiter);
                var stringEncrypt = (id + word[4] + "3uNi@rCK$L$om40dNnhX)#jV2$40wwbr_bAK99%E");
                var sha256 = EncriptSha256.EncriptStringToSha256(stringEncrypt);

                await connecionSocial.ConnexionSocial("facebook", sha256, ObjFBHelper.AccessToken, id);
                var res = connecionSocial.Received;
                GetUser(res);
            }
        }

        #endregion
    }
}
