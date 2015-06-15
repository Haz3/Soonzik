using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using Windows.Foundation.Collections;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;
using Genre = SoonZik.HttpRequest.Poco.Genre;

namespace SoonZik.ViewModel
{
    public class ExplorerViewModel : ViewModelBase
    {
        #region Attribute

        public INavigationService Navigation;

        private ObservableCollection<Genre> _listGenres;
        public ObservableCollection<Genre> ListGenres
        {
            get { return _listGenres; }
            set
            {
                _listGenres = value;
                RaisePropertyChanged("ListGenres");
            }
        }

        private ObservableCollection<Music> _listMusique;
        public ObservableCollection<Music> ListMusique
        {
            get { return _listMusique; }
            set
            {
                _listMusique = value;
                RaisePropertyChanged("ListMusique");
            }
        }

        private ObservableCollection<User> _listArtiste;
        public ObservableCollection<User> ListArtiste
        {
            get { return _listArtiste; }
            set
            {
                _listArtiste = value;
                RaisePropertyChanged("ListArtiste");
            }
        }

        public Music SelectedMusic { get; set; }
        public static Music PlayerSelectedMusic { get; set; }
        public RelayCommand MusiCommand { get; set; } 
        #endregion

        #region Ctor

        public ExplorerViewModel()
        {
            Navigation = new NavigationService();
            var task = Task.Run(async () => await LoadContent());
            task.Wait();
            MusiCommand = new RelayCommand(MusiCommandExecute);
        }

        #endregion

        #region Method
        public async Task LoadContent()
        {
            var request = new HttpRequestGet();
            var listGenre = (List<Genre>)await request.GetListObject(new List<HttpRequest.Poco.Genre>(), "genres");
            var listUser = (List<User>)await request.GetListObject(new List<HttpRequest.Poco.User>(), "users");
            var listMusic = (List<Music>)await request.GetListObject(new List<HttpRequest.Poco.Music>(), "musics");
            _listMusique = new ObservableCollection<Music>();
            _listArtiste = new ObservableCollection<User>();
            _listGenres = new ObservableCollection<Genre>();

            foreach (var item in listGenre)
                _listGenres.Add(item);

            foreach (var item in listUser)
            {
                var res = (Artist)await request.GetArtist(new Artist(), "users", item.Id.ToString());
                if (res.artist)
                    _listArtiste.Add(item);
            }


            foreach (var item in listMusic)
                _listMusique.Add(item);
        }


        private void MusiCommandExecute()
        {
            Singleton.Instance().SelectedMusicSingleton = SelectedMusic;
            Navigation.Navigate(new PlayerControl().GetType());
        }
        #endregion
    }
}
