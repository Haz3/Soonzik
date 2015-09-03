using System;
using System.Linq;
using System.Windows.Input;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

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
            NewUser.address = new Address();
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
        public ICommand ValidateCommand { get; private set; }
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
        public ICommand PasswordBoxCommand { get; private set; }

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
                    month = "0" + Birthday.Month.ToString();
                }
                if (Birthday.Day < 10)
                {
                    day = "0" + Birthday.Day;
                }
                NewUser.birthday = Birthday.Year + "-" + month + "-" + day + " 00:00:00";
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
            var res = await postRequest.Save(NewUser, "", _password);
            new MessageDialog("Inscription OK").ShowAsync();
        }

        #endregion
    }
}