using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;

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

        #endregion
        
        #region Ctor
        public ConnexionViewModel()
        {
            _connexionCommand = new RelayCommand(MakeConnexion);
        }
        #endregion

        #region Method
        private void MakeConnexion()
        {
            var test = new MessageDialog("user = " + Username + " pass = " + Password);
            test.ShowAsync();
        }
        #endregion
    }
}
