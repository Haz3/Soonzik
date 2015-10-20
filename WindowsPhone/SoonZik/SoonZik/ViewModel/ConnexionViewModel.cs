using System;
using System.Collections.ObjectModel;
using System.Windows.Input;
using Windows.ApplicationModel.Activation;
using Windows.ApplicationModel.Core;
using Windows.Storage;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml.Media.Imaging;
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

namespace SoonZik.ViewModel
{
    public class ConnexionViewModel : ViewModelBase, IWebAuthenticationBrokerContinuable
    {
        #region Attribute

        private readonly FaceBookHelper ObjFBHelper = new FaceBookHelper();
        private FacebookClient fbclient = new FacebookClient();

        public ICommand SelectionCommand { get; private set; }

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
                _username = value;
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

        public RelayCommand ConnexionCommand { get; private set; }

        public RelayCommand InscritpiomCommand { get; private set; }

        public RelayCommand FacebookTapped { get; private set; }

        public ICommand TwitterTapped { get; private set; }
        public ICommand GoogleTapped { get; private set; }

        public INavigationService Navigation;

        #endregion

        #region Ctor

        public ConnexionViewModel()
        {
            ProgressOn = false;
            Singleton.Singleton.Instance().SelectedMusicSingleton = new ObservableCollection<Music>();
            Navigation = new NavigationService();
            ConnexionCommand = new RelayCommand(MakeConnexion);
            FacebookTapped = new RelayCommand(MakeFacebookConnection);
            SelectionCommand = new RelayCommand(SelectionExecute);
            InscritpiomCommand = new RelayCommand(ExecuteInscription);
            TwitterTapped = new RelayCommand(TwitterCommandExecute);
            GoogleTapped = new RelayCommand(GoogleTappedExecute);
            if (_localSettings != null && (string) _localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                _password = _localSettings.Values["SoonZikPassWord"].ToString();
                _username = _localSettings.Values["SoonZikUserName"].ToString();
            }
            Network.InternetConnectionChanged += NetworkOnInternetConnectionChanged;
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

        private void NetworkOnInternetConnectionChanged(object sender,
            InternetConnectionChangedEventArgs internetConnectionChangedEventArgs)
        {
            if (!Network.IsConnected)
            {
            }
        }

        private async void MakeConnexion()
        {
            var dispatcher = CoreApplication.MainView.CoreWindow.Dispatcher;

            await dispatcher.RunAsync(CoreDispatcherPriority.Normal, async () =>
            {
                if (_username != null && _password != null)
                {
                    ProgressOn = true;
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
                    Singleton.Singleton.Instance().CurrentUser =
                        JsonConvert.DeserializeObject(stringJson, typeof (User)) as User;
                    Singleton.Singleton.Instance().CurrentUser.profilImage =
                        new BitmapImage(new Uri(
                            Constant.UrlImageUser + Singleton.Singleton.Instance().CurrentUser.image,
                            UriKind.RelativeOrAbsolute));
                    foreach (var friend in Singleton.Singleton.Instance().CurrentUser.friends)
                    {
                        friend.profilImage =
                            new BitmapImage(new Uri(Constant.UrlImageUser + friend.image, UriKind.RelativeOrAbsolute));
                    }
                    ServiceLocator.Current.GetInstance<MyNetworkViewModel>().UpdateFriend();
                }
                catch (Exception e)
                {
                    new MessageDialog("Erreur de connexion" + e).ShowAsync();
                    ProgressOn = false;
                }
                WriteInformation();
                Navigation.Navigate(typeof (MainView));
                ProgressOn = false;
            }
            else
            {
                new MessageDialog("Reseau insufisant").ShowAsync();
                ProgressOn = false;
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

        private void TwitterCommandExecute()
        {
        }

        private void GoogleTappedExecute()
        {
        }

        public async void ContinueWithWebAuthenticationBroker(WebAuthenticationBrokerContinuationEventArgs args)
        {
            ProgressOn = true;
            ObjFBHelper.ContinueAuthentication(args);
            if (ObjFBHelper.AccessToken != null)
            {
                fbclient = new FacebookClient(ObjFBHelper.AccessToken);
                Singleton.Singleton.Instance().MyFacebookClient = new FacebookClient(ObjFBHelper.AccessToken);

                dynamic result = await fbclient.GetTaskAsync("me");
                string id = result.id;

                var connecionSocial = new HttpRequestPost();
                var getKey = new HttpRequestGet();

                var key = await getKey.GetSocialToken(id, "facebook") as string;
                char[] delimiter = {' ', '"', '{', '}'};
                var word = key.Split(delimiter);
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