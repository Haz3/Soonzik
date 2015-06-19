using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;
using System.Windows.Input;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class ProfilArtisteViewModel : ViewModelBase
    {
        #region Attribute

        private User _theArtiste;
        public User TheArtiste
        {
            get { return _theArtiste; }
            set
            {
                _theArtiste = value;
                RaisePropertyChanged("TheArtiste");
            }
        }

        private List<Album> _listAlbums;
        public List<Album> ListAlbums
        {
            get { return _listAlbums; }
            set
            {
                _listAlbums = value;
                RaisePropertyChanged("ListAlbums");
            }
        }

        public static User TheUser { get; set; }
        
        private ICommand _selectionCommand;
        public ICommand SelectionCommand
        {
            get { return _selectionCommand; }
        }

        private RelayCommand _itemClickCommand;
        public RelayCommand ItemClickCommand
        {
            get { return _itemClickCommand; }
            set
            {
                _itemClickCommand = value;
                RaisePropertyChanged("ItemClickCommand");
            }
        }

        private Album _theAlbum;
        public Album TheAlbum
        {
            get { return _theAlbum; }
            set
            {
                _theAlbum = value;
                RaisePropertyChanged("TheAlbum");
            }
        }
        #endregion

        #region ctor

        public ProfilArtisteViewModel()
        {
            if (TheUser != null)
            {
                _selectionCommand = new RelayCommand(SelectionExecute);
                ItemClickCommand = new RelayCommand(ItemClickCommandExecute);
            }
        }

        private void ItemClickCommandExecute()
        {
            AlbumViewModel.MyAlbum = TheAlbum;
            GlobalMenuControl.MyGrid.Children.Clear();
            GlobalMenuControl.MyGrid.Children.Add(new AlbumView());
        }

        private void SelectionExecute()
        {
            TheArtiste = TheUser;
            var task = Task.Run(async () => await Charge());
            task.Wait();
        }

        #endregion

        #region Method
        public async Task Charge()
        {
            var request = new HttpRequestGet();
            try
            {
                var artist = (Artist)await request.GetArtist(new Artist(), "users", TheArtiste.id.ToString());
                ListAlbums = artist.albums;
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.ToString());
            }
        }
        #endregion
    }
}
