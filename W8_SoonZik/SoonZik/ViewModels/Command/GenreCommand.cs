using SoonZik.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace SoonZik.ViewModels.Command
{
    class GenreCommand : ICommand
    {
        //GenreViewModel _ViewModel;
        Genre _genre;

        public GenreCommand()
        {

        }

        public GenreCommand(Genre genre)
        {
            _genre = genre;
        }

        // ADD & REMOVE to avoid warning ...
        public event EventHandler CanExecuteChanged { add { } remove { } }

        public bool CanExecute(object parameter)
        {
            return true;
        }

        public void Execute(object parameter)
        {
           new GenreViewModel(_genre.id);
        }
    }
}
