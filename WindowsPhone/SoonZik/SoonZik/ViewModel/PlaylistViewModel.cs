using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class PlaylistViewModel : ViewModelBase
    {
        #region Attribute
        public ICommand LoadedCommand { get; private set; }
        public ICommand MoreOptionCommand { get; private set; }
        public static ICommand UpdatePlaylist { get; private set; }

        public static Playlist PlaylistTmp { get; set; }

        public static MessagePrompt MessagePrompt { get; set; }
        private bool _moreOption;

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
            MoreOptionCommand = new RelayCommand(MoreOptionCommandExecute);
            UpdatePlaylist = new RelayCommand(UpdatePlaylistExecute);
        }


        #endregion

        #region Method

        private void UpdatePlaylistExecute()
        {
            var request = new HttpRequestGet();

            var res = request.GetObject(new Playlist(), "playlists", ThePlaylist.id.ToString());
            res.ContinueWith(delegate(Task<object> tmp)
            {
                var pl = tmp.Result as Playlist;
                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                    () =>
                    {
                        if (pl != null)
                            ThePlaylist = pl;
                    });
            });
        }

        private void MoreOptionCommandExecute()
        {
            _moreOption = true;
            MoreOptionPopUp.ThePlaylist = ThePlaylist;
            var newsBody = new MoreOptionPopUp(SelectedMusic);
            MessagePrompt = new MessagePrompt
            {
                Width = 300,
                Height = 450,
                IsAppBarVisible = false,
                VerticalAlignment = VerticalAlignment.Center,
                Body = newsBody,
                Opacity = 0.6
            };
            MessagePrompt.ActionPopUpButtons.Clear();
            MessagePrompt.Show();
        }

        public void OnLoadedPageExecute()
        {
            ThePlaylist = PlaylistTmp;
            ListMusics = new ObservableCollection<Music>();
        }
        #endregion
    }
}
