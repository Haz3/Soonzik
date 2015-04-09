using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class ConnexionViewModel : ViewModelBase
    {
        #region Attribute

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

        public Utils.INavigationService Navigation;

        #endregion
        
        #region Ctor
        public ConnexionViewModel()
        {
            Navigation = new NavigationService();
            _connexionCommand = new RelayCommand(MakeConnexion);
        }
        #endregion

        #region Method
        private async void MakeConnexion()
        {
            var test = new MessageDialog("user = " + Username + " pass = " + Password);
            test.ShowAsync();
            var dispatcher = CoreApplication.MainView.CoreWindow.Dispatcher;

            await dispatcher.RunAsync(Windows.UI.Core.CoreDispatcherPriority.Normal, () => {
                                                                                               var http = new HttpReq();
            });
            Navigation.Navigate(typeof(MainView));
        }
        #endregion
    }
}
