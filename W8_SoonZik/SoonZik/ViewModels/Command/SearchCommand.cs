using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace SoonZik.ViewModels.Command
{
    class SearchCommand : ICommand
    {
        SearchViewModel _ViewModel;

        public SearchCommand(SearchViewModel ViewModel)
        {
            _ViewModel = ViewModel;
        }

        // ADD & REMOVE to avoid warning ...
        public event EventHandler CanExecuteChanged { add { } remove { } }

        public bool CanExecute(object parameter)
        {
            //if (parameter as string == null)
            //    return false;
            return true;
        }

        public void Execute(object parameter)
        {
            _ViewModel.search();
        }
    }
}
