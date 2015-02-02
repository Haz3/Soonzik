using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml.Data;
using ConvertedListViewApp;
using SoonZik.Model;
using  GalaSoft.MvvmLight;

namespace SoonZik.ViewModel
{
    public class FriendViewModel : ViewModelBase
    {
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
        public FriendViewModel()
        {
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
    }
}
