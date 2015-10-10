using System;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml.Media.Imaging;
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
    public class InscriptionViewModel : ViewModelBase
    {
        #region Ctor

        public InscriptionViewModel()
        {
            ValidateCommand = new RelayCommand(ValidateExecute);
            PasswordBoxCommand = new RelayCommand(PasswordBoxCommandExecute);
            NewUser = new User();
            NewAddress = new Address();
            Navigation = new NavigationService();
        }

        #endregion

        #region Attribute

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

        private DateTimeOffset _birthday;

        public DateTimeOffset Birthday
        {
            get { return _birthday; }
            set
            {
                _birthday = value;
                RaisePropertyChanged("Birthday");
            }
        }

        private User _newUser;

        public User NewUser
        {
            get { return _newUser; }
            set
            {
                _newUser = value;
                RaisePropertyChanged("NewUser");
            }
        }

        private Address _newAddress;

        public Address NewAddress
        {
            get { return _newAddress; }
            set
            {
                _newAddress = value;
                RaisePropertyChanged("NewAddress");
            }
        }

        public ICommand PasswordBoxCommand { get; private set; }
        public ICommand ValidateCommand { get; private set; }
        public ICommand CheckAdress { get; private set; }

        public INavigationService Navigation;

        #endregion

        #region Method

        private void PasswordBoxCommandExecute()
        {
            if (Password.Length < 8 && Password != null)
            {
                new MessageDialog("Password need 8").ShowAsync();
            }
        }

        private void ValidateExecute()
        {
            if (EmailHelper.IsValidEmail(NewUser.email))
            {
                var month = Birthday.Month.ToString();
                var day = Birthday.Day.ToString();
                if (Birthday.Month < 10)
                {
                    month = "0" + Birthday.Month;
                }
                if (Birthday.Day < 10)
                {
                    day = "0" + Birthday.Day;
                }
                NewUser.birthday = Birthday.Year + "-" + month + "-" + day + " 00:00:00";

                if (NewAddress.City != null)
                {
                    NewUser.address = new Address();
                    NewUser.address = NewAddress;
                }

                PostUser();
            }
            else
            {
                new MessageDialog("Email not Valid").ShowAsync();
            }
        }

        private async void PostUser()
        {
            var postRequest = new HttpRequestPost();
            var res = await postRequest.Save(NewUser, "", Password);
            new MessageDialog("Inscription OK").ShowAsync();
            MakeConnexion();
        }

        private async void MakeConnexion()
        {
            var dispatcher = CoreApplication.MainView.CoreWindow.Dispatcher;

            await dispatcher.RunAsync(CoreDispatcherPriority.Normal, async () =>
            {
                if (NewUser.username != string.Empty && _password != string.Empty)
                {
                    var connec = new HttpRequestPost();
                    await connec.ConnexionSimple(NewUser.email, _password);
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
                        new BitmapImage(
                            new Uri(
                                "http://soonzikapi.herokuapp.com/assets/usersImage/avatars/" +
                                Singleton.Singleton.Instance().CurrentUser.image, UriKind.RelativeOrAbsolute));

                    ServiceLocator.Current.GetInstance<MyNetworkViewModel>().UpdateFriend();
                }
                catch (Exception e)
                {
                    new MessageDialog("Erreur de connexion" + e).ShowAsync();
                }
                Navigation.Navigate(typeof (MainView));
            }
            else
            {
                new MessageDialog("Erreur de connexion Code 502").ShowAsync();
            }
        }

        #endregion
    }
}