using System;
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

        #endregion

        #region Ctor

        public InscriptionViewModel()
        {
            ValidateCommand = new RelayCommand(ValidateExecute);
            NewUser = new User();
            NewUser.address = new Address();
        }

        private void ValidateExecute()
        {
            if (EmailHelper.IsValidEmail(NewUser.email))
            {
                NewUser.birthday = Birthday.Year + "/" + Birthday.Month + "/" + Birthday.Day + "%20" + Birthday.Hour +
                                   ":" + Birthday.Minute + ":" + Birthday.Second;
                PostUser();
            }
            else
            {
                new MessageDialog("").ShowAsync();
            }
        }

        private async void PostUser()
        {
            var postRequest = new HttpRequestPost();
            var res = await postRequest.Save(NewUser, "", _password);
        }

        #endregion

        #region Method

        #endregion
    }
}