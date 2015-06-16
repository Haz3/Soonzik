using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Input;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

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

        #endregion

        #region ctor

        public ProfilArtisteViewModel()
        {
            if (TheUser != null)
            {
                _selectionCommand = new RelayCommand(SelectionExecute);
            }
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
                var artist = (Artist)await request.GetArtist(new Artist(), "users", TheArtiste.Id.ToString());
                ListAlbums = artist.albums;
            }
            catch (Exception e)
            {

            }
        }
        #endregion
    }
}
