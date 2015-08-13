﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace SoonZik.ViewModels.Command
{
    class AddFriendCommand : ICommand
    {
        UserEditViewModel _ViewModel;

        public AddFriendCommand(UserEditViewModel ViewModel)
        {
            _ViewModel = ViewModel;
        }

        // ADD & REMOVE to avoid warning ...
        public event EventHandler CanExecuteChanged { add { } remove { } }

        public bool CanExecute(object parameter)
        {
            //if (_ViewModel.new_friend != null)
            //    return true;
            //return false;
            return true;
        }

        public void Execute(object parameter)
        {
            _ViewModel.add_friend();
        }
    }
}
