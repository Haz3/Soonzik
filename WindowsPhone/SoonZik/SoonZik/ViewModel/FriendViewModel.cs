using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using ConvertedListViewApp;
using GalaSoft.MvvmLight.Command;
using SoonZik.Model;
using  GalaSoft.MvvmLight;

namespace SoonZik.ViewModel
{
    public class FriendViewModel : ViewModelBase
    {
        #region Attribute
        public ObservableCollection<Users> Sources { get; set; }
        private List<AlphaKeyGroups<Users>> _itemSource;
        public List<AlphaKeyGroups<Users>> ItemSource
        {
            get { return _itemSource; }
            set
            {
                _itemSource = value;
                RaisePropertyChanged("ItemSource");
            }
        }

        public RelayCommand TappedCommand
        {
            get; private set; 
        }

        #endregion

        #region Ctor
        public FriendViewModel()
        {
            TappedCommand = new RelayCommand(ExecuteTappedCommand, CanExecute);
            Sources = new ObservableCollection<Users>()
            {
                new Users("Gery", "Baudry", "gery@budry.com"),
                new Users("Guillaume", "Boufflers", "gui@llaume.com"),
                new Users("John", "Kaudry", "johny@kaudry.com"),
                new Users("Maxime", "Sauvry", "max@xime.com"),
                new Users("MAurice", "Maud", "Mau@MAu.com"),
                new Users("Joe", "chat", "gery@char.com"),
                new Users("mickale", "fly", "gery@fly.com"),
                new Users("nounou", "Vola", "gery@vola.com"),
                new Users("Henry", "Thierry", "gery@thiery.com")
            };

            ItemSource = AlphaKeyGroups<Users>.CreateGroups(Sources, CultureInfo.CurrentUICulture, s => s.MyLastName, true);
        }

        #endregion

        #region Method
        private bool CanExecute()
        {
            throw new NotImplementedException();
        }

        private void ExecuteTappedCommand()
        {
            //Allez sur le profil de l'element
        }

        #endregion
    }
}
