using System.Windows.Input;
using Windows.ApplicationModel.Resources;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;

namespace SoonZik.ViewModel
{
    public class AboutViewModel : ViewModelBase
    {
        #region Ctor

        public AboutViewModel()
        {
            SendCommand = new RelayCommand(SendFeedBack);
        }

        #endregion

        private void SendFeedBack()
        {
            if (Email != null && Username != null && Object != null && Comment != null)
            {
                //TODO send to the serveur
            }
            else
            {
                var loader = new ResourceLoader();
                new MessageDialog(loader.GetString("ErrorAbout")).ShowAsync();
            }
        }

        #region Attribute

        public ICommand SendCommand { get; private set; }
        private string _email;

        public string Email
        {
            get { return _email; }
            set
            {
                _email = value;
                RaisePropertyChanged("Email");
            }
        }

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

        private string _object;

        public string Object
        {
            get { return _object; }
            set
            {
                _object = value;
                RaisePropertyChanged("Object");
            }
        }

        private string _comment;

        public string Comment
        {
            get { return _comment; }
            set
            {
                _comment = value;
                RaisePropertyChanged("Comment");
            }
        }

        #endregion

        #region Method

        #endregion
    }
}