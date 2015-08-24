using System.Windows.Input;
using Windows.Phone.UI.Input;
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
            //CurrentUser = Singleton.Instance().CurrentUser;
            //HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;
            SelectionCommand = new RelayCommand(SelectionExecute);
            AddCommand = new RelayCommand(AddFriendExecute);
            //Navigation.GoBack();
        }

        #endregion


        #region Attribute

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

        private void AddFriendExecute()
        {
            AddDelFriendHelpers.GetUserKeyForFriend(CurrentUser.id.ToString());
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