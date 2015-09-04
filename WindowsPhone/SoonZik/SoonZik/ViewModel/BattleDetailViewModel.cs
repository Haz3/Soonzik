using System;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class BattleDetailViewModel : ViewModelBase
    {
        #region Ctor

        public BattleDetailViewModel()
        {
            CanVote = true;
            VoteArtisteOneCommand = new RelayCommand(VoteArtisteOneCommandExcecute);
            VoteArtisteTwoCommand = new RelayCommand(VoteArtisteTwoCommandExcecute);
            InitializeData();
            InitializeTimer();
        }

        #endregion

        #region Attribute

        public ICommand VoteArtisteOneCommand { get; set; }
        public ICommand VoteArtisteTwoCommand { get; set; }

        private bool _canVote;

        public bool CanVote
        {
            get { return _canVote; }
            set
            {
                _canVote = value;
                RaisePropertyChanged("CanVote");
            }
        }

        private string _pourcentageVote1;

        public string PourcentageVote1
        {
            get { return _pourcentageVote1; }
            set
            {
                _pourcentageVote1 = value;
                RaisePropertyChanged("PourcentageVote1");
            }
        }

        private string _pourcentageVote2;

        public string PourcentageVote2
        {
            get { return _pourcentageVote2; }
            set
            {
                _pourcentageVote2 = value;
                RaisePropertyChanged("PourcentageVote2");
            }
        }

        private string _jourdRestants;

        public string JoursRestants
        {
            get { return _jourdRestants; }
            set
            {
                _jourdRestants = value;
                RaisePropertyChanged("JoursRestants");
            }
        }

        private string _heuresRestantes;

        public string HeuresRestantes
        {
            get { return _heuresRestantes; }
            set
            {
                _heuresRestantes = value;
                RaisePropertyChanged("HeuresRestantes");
            }
        }

        private string _minutesRestantes;

        public string MinutesRestantes
        {
            get { return _minutesRestantes; }
            set
            {
                _minutesRestantes = value;
                RaisePropertyChanged("MinutesRestantes");
            }
        }

        private string _secondesRestantes;

        public string SecondesRestantes
        {
            get { return _secondesRestantes; }
            set
            {
                _secondesRestantes = value;
                RaisePropertyChanged("SecondesRestantes");
            }
        }

        private ArtistOne _artistOne;

        public ArtistOne ArtistOne
        {
            get { return _artistOne; }
            set
            {
                _artistOne = value;
                RaisePropertyChanged("ArtistOne");
            }
        }

        private ArtistTwo _artisTwo;

        public ArtistTwo ArtistTwo
        {
            get { return _artisTwo; }
            set
            {
                _artisTwo = value;
                RaisePropertyChanged("ArtistTwo");
            }
        }

        public static Battle CurrentBattle { get; set; }

        private DateTime _endDate;
        private DispatcherTimer _timer;

        #endregion

        #region Method

        private void InitializeData()
        {
            ArtistOne = CurrentBattle.artist_one;
            ArtistTwo = CurrentBattle.artist_two;
            var a = 0.0;
            var b = 0.0;
            foreach (var vote in CurrentBattle.votes)
            {
                if (CurrentBattle.artist_one.id == vote.artist_id)
                {
                    a += 1.0;
                }
                else if (CurrentBattle.artist_two.id == vote.artist_id)
                {
                    b += 1.0;
                }
                if (Singleton.Instance().CurrentUser.id == vote.user_id)
                {
                    CanVote = false;
                }
            }
            a = (a*100)/CurrentBattle.votes.Count;
            b = (b*100)/CurrentBattle.votes.Count;
            PourcentageVote1 = a + " %";
            PourcentageVote2 = b + " %";
        }

        private void InitializeTimer()
        {
            char[] delimiter = {' ', '-', ':'};
            var word = CurrentBattle.date_end.Split(delimiter);

            //_endDate = new DateTime(Int32.Parse(word[0]), Int32.Parse(word[1]), Int32.Parse(word[2]), Int32.Parse(word[3]), Int32.Parse(word[4]), Int32.Parse(word[5]));
            _endDate = new DateTime(2015, 6, 29, 0, 0, 0);
            _timer = new DispatcherTimer();
            _timer.Tick += CountDown;
            _timer.Interval = TimeSpan.FromSeconds(1);
            _timer.Start();
        }

        private void CountDown(object sender, object e)
        {
            var remainingTime = _endDate.Subtract(DateTime.Now);

            JoursRestants = string.Format("{0}", remainingTime.Days);
            HeuresRestantes = string.Format("{0}", remainingTime.Hours);
            MinutesRestantes = string.Format("{0}", remainingTime.Minutes);
            SecondesRestantes = string.Format("{0}", remainingTime.Seconds);
        }


        private void VoteArtisteOneCommandExcecute()
        {
            GetUserKeyForVote(CurrentBattle.artist_one.id.ToString());
        }

        private void VoteArtisteTwoCommandExcecute()
        {
            GetUserKeyForVote(CurrentBattle.artist_two.id.ToString());
        }

        public void GetUserKeyForVote(string artistId)
        {
            var post = new HttpRequestPost();
            var get = new HttpRequestGet();

            var userKey = get.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                var key = task.Result as string;
                if (key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                    var cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);
                    Vote(post, cryptographic, get, artistId);
                }
            });
        }

        private void Vote(HttpRequestPost post, string cryptographic, HttpRequestGet get, string artistId)
        {
            var resPost = post.Vote(cryptographic, CurrentBattle.id.ToString(), artistId,
                Singleton.Instance().CurrentUser.id.ToString());
            resPost.ContinueWith(delegate(Task<string> tmp)
            {
                var test = tmp.Result;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        var resGet = get.GetObject(new Battle(), "battles", CurrentBattle.id.ToString());
                        resGet.ContinueWith(
                            delegate(Task<object> newBattle) { CurrentBattle = newBattle.Result as Battle; });
                        InitializeData();
                    });
                }
            });
        }

        #endregion
    }
}