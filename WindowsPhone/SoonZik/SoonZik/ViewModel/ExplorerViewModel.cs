using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class ExplorerViewModel : ViewModelBase
    {
        #region Attribute
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

        #endregion

        #region Ctor

        public ExplorerViewModel()
        {
            var task = Task.Run(async () => await ChargeGenre());
            task.Wait();

            var task2 = Task.Run(async () => await ChargeArtiste());
            task.Wait();
            
            var task3 = Task.Run(async () => await ChargeMusic());
            task3.Wait();
        }
        #endregion

        #region Method
        public async Task ChargeGenre()
        {
            var test = new HttpRequestGet();
            var listGenre = (List<Genre>)await test.GetListObject(new List<HttpRequest.Poco.Genre>(), "genres");
            _listGenres = new ObservableCollection<Genre>();

            foreach (var item in listGenre)
                _listGenres.Add(item);
        }

        public async Task ChargeArtiste()
        {
            var test = new HttpRequestGet();
            var listUser = (List<User>)await test.GetListObject(new List<HttpRequest.Poco.User>(), "users");
            _listArtiste = new ObservableCollection<User>();

            foreach (var item in listUser)
            {
                var res = (Artist) await test.GetArtist(new Artist(), "users", item.Id.ToString());
                if (res.artist)
                    _listArtiste.Add(item);
            }
        }

        public async Task ChargeMusic()
        {
            var test = new HttpRequestGet();
            var listMusic = (List<Music>)await test.GetListObject(new List<HttpRequest.Poco.Music>(), "musics");
            _listMusique = new ObservableCollection<Music>();

            foreach (var item in listMusic)
                _listMusique.Add(item);
        }
        #endregion
    }
}
