using System.Text;
using System.Windows.Input;
using Windows.Phone.UI.Input;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Ioc;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class ProfilUserViewModel : ViewModelBase
    {
        #region Attribute

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
        
        private ICommand _selectionCommand;
        public ICommand SelectionCommand
        {
            get { return _selectionCommand; }
        }
         private ICommand _editClickCommand;
        public ICommand EditClickCommand
        {
            get { return _editClickCommand; }
        }

        public bool NeedUpdate;

        private bool _canUdpate;

        public bool CanUpdate
        {
            get { return _canUdpate; }
            set
            {
                _canUdpate = value;
                RaisePropertyChanged("CanUpdate");
            }
        }

        private string _buttonContent;

        public string ButtonContent
        {
            get { return _buttonContent; }
            set
            {
                _buttonContent = value;
                RaisePropertyChanged("ButtonContent");
            }
        }
        #endregion

        #region Ctor
        [PreferredConstructor]
        public ProfilUserViewModel()
        {
            Navigation = new NavigationService();
            //CurrentUser = Singleton.Instance().CurrentUser;
            NeedUpdate = false;
            CanUpdate = false;
            ButtonContent = "Editer mes informations";
            //HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;
            _selectionCommand = new RelayCommand(SelectionExecute);
            _editClickCommand = new RelayCommand(EditInformationExecute);

            //Navigation.GoBack();
        }

        #endregion

        #region Method
        private void SelectionExecute()
        {
            if (Singleton.Instance().ItsMe)
                CurrentUser = Singleton.Instance().CurrentUser;
            else if (!Singleton.Instance().ItsMe)
                CurrentUser = Singleton.Instance().SelectedUser;
        }


        private void EditInformationExecute()
        {
            if (!NeedUpdate)
            {
                CanUpdate = true;
                ButtonContent = "Mettre a jour mes informations";
                NeedUpdate = true;
            }
            else if (NeedUpdate)
            {
                CanUpdate = false;
                new MessageDialog("Vos informations son mise a jour" + CurrentUser.Email).ShowAsync();
                ButtonContent = "Editer mes informations";
                NeedUpdate = false;
            }
        }


        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs backPressedEventArgs)
        {
            backPressedEventArgs.Handled = true;
            Navigation.GoBack();
        }
        
        #endregion
    }
}
