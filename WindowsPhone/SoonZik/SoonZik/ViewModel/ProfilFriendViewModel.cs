﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
    public class ProfilFriendViewModel : ViewModelBase
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

        #endregion

        #region Ctor
        [PreferredConstructor]
        public ProfilFriendViewModel()
        {
            Navigation = new NavigationService();
            //CurrentUser = Singleton.Instance().CurrentUser;
            //HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;
            _selectionCommand = new RelayCommand(SelectionExecute);

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

        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs backPressedEventArgs)
        {
            backPressedEventArgs.Handled = true;
            Navigation.GoBack();
        }
        
        #endregion
    }
}