using System;
using System.Collections.ObjectModel;
using System.Windows.Input;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class PlaylistViewModel : ViewModelBase
    {
        #region Attribute
        public ICommand LoadedCommand { get; private set; }
        public static Playlist PlaylistTmp { get; set; }
        private Playlist _thePlaylist;
        public Playlist ThePlaylist
        {
            get { return _thePlaylist; }
            set
            {
                _thePlaylist = value; 
                RaisePropertyChanged("ThePlaylist");
            }
        }

        private ObservableCollection<Music> _listMusics; 
        public ObservableCollection<Music> ListMusics
        {
            get { return _listMusics; }
            set
            {
                _listMusics = value;
                RaisePropertyChanged("ListMusics");
            }
        }

        private Music _selectedMusic;
        public Music SelectedMusic
        {
            get { return _selectedMusic; }
            set { _selectedMusic = value; RaisePropertyChanged("SelectedMusic"); }
        }
        #endregion

        #region Ctor

        public PlaylistViewModel()
        {
            LoadedCommand = new RelayCommand(OnLoadedPageExecute);
        }
        #endregion

        #region Method

        private void OnLoadedPageExecute()
        {
            ThePlaylist = PlaylistTmp;
            ListMusics = new ObservableCollection<Music>();
        }
        #endregion
    }
}
