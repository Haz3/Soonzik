using System;
using Windows.Phone.UI.Input;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class ProfilUserViewModel : ViewModelBase
    {
        #region Attribute
        public User CurrentUser { get; set; }
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


        private RelayCommand _selectionCommand;
        public RelayCommand SelectionCommand
        {
            get { return _selectionCommand; }
        }
        #endregion

        #region Ctor

        public ProfilUserViewModel()
        {
            Navigation = new NavigationService();
            CurrentUser = Singleton.Instance().CurrentUser;
            HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;
            _selectionCommand = new RelayCommand(SelectionExecute);
            //Navigation.GoBack();
        }

        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs backPressedEventArgs)
        {
            backPressedEventArgs.Handled = true;
            Navigation.GoBack();
        }

        #endregion

        #region Method
        private void SelectionExecute()
        {
            var test = _selectUser;
        }
        
        #endregion
    }
}
