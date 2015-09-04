using System.Windows.Input;
using Windows.ApplicationModel.Resources;
using Windows.Phone.UI.Input;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Ioc;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class ProfilFriendViewModel : ViewModelBase
    {
        #region Ctor

        [PreferredConstructor]
        public ProfilFriendViewModel()
        {
            Navigation = new NavigationService();
            SelectionCommand = new RelayCommand(SelectionExecute);
            AddCommand = new RelayCommand(AddFriendExecute);

            CheckIfFriend();
        }

        #endregion

        #region Attribute

        private bool _friend;

        private string _buttonFriendText;

        public string ButtonFriendText
        {
            get { return _buttonFriendText; }
            set
            {
                _buttonFriendText = value;
                RaisePropertyChanged("ButtonFriendText");
            }

        }

        public ICommand AddCommand { get; private set; }

        private User _currentUser;

        public User CurrentUser
        {
            get { return _currentUser; }
            set
            {
                _currentUser = value;
                RaisePropertyChanged("CurrentUser");
            }
        }

        public static User UserFromButton { get; set; }

        public INavigationService Navigation;

        public User SelectUser
        {
            get { return _selectUser; }
            set
            {
                _selectUser = value;
                RaisePropertyChanged("SelectUser");
            }
        }

        private User _selectUser;

        public ICommand SelectionCommand { get; private set; }

        #endregion

        #region Method

        private void CheckIfFriend()
        {
            var loader = new ResourceLoader();
            foreach (var friend in Singleton.Instance().CurrentUser.friends)
            {
                if (friend.username == UserFromButton.username)
                {
                    ButtonFriendText = loader.GetString("DelFriend");
                    _friend = true;
                }
                else
                {
                    ButtonFriendText = loader.GetString("AddFriend");
                    _friend = false;
                }

            }
        }

        private void AddFriendExecute()
        {
            var loader = new ResourceLoader();
            if (CurrentUser != null)
            {
                AddDelFriendHelpers.GetUserKeyForFriend(CurrentUser.id.ToString(), _friend);
                _friend = !_friend;
                ButtonFriendText = loader.GetString(_friend ? "DelFriend" : "AddFriend");
            }
            else
                new MessageDialog("Erreur lors de la recuperation de l'id user").ShowAsync();
        }

        private void SelectionExecute()
        {
            CurrentUser = UserFromButton;
        }

        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs backPressedEventArgs)
        {
            backPressedEventArgs.Handled = true;
            Navigation.GoBack();
        }

        #endregion
    }
}