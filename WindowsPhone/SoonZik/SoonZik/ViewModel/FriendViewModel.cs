using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.Storage;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class FriendViewModel : ViewModelBase
    {
        #region Method
        private void Execute()
        {
            MeaagePrompt = new MessagePrompt
            {
                IsAppBarVisible = true,
                VerticalAlignment = VerticalAlignment.Center,
                Body = new ButtonFriendPopUp(SelectedUser.id),
                Opacity = 0.6
            };
            MeaagePrompt.Show();
        }

        private void FollowerCommandExecute()
        {
            ProfilArtisteViewModel.TheUser = SelectedUser;
            GlobalMenuControl.SetChildren(new ProfilArtiste());
        }

        public void UpdateFriend()
        {
            Sources = Singleton.Instance().CurrentUser.friends;
            ItemSource = AlphaKeyGroups<User>.CreateGroups(Sources, CultureInfo.CurrentUICulture, s => s.username, true);
        }

        private void TweetCommandExecute()
        {
            
        }

        private void SendTweetExecute()
        {
            
        }

        private void LoadTweet()
        {
            ListTweets = new ObservableCollection<Tweets>();
            var req = new HttpRequestGet();
            var listTweets = req.GetListObject(new List<Tweets>(), "tweets");
            listTweets.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Tweets>;
                if (res != null)
                {
                    foreach (var item in res)
                    {
                        ListTweets.Add(item);
                    }
                }
            });

        }
        #endregion

        #region Attribute
        public ICommand FollowerCommand { get; private set; }
        public ICommand TweetCommand { get; private set; }
        public ICommand LoadedCommand { get; private set; }
        public ICommand SendTweet { get; private set; }
        private readonly ApplicationDataContainer _localSettings = ApplicationData.Current.LocalSettings;
        public static MessagePrompt MeaagePrompt { get; set; }
        private ObservableCollection<User> _sources;
        public ObservableCollection<User> Sources
        {
            get { return _sources; }
            set
            {
                _sources = value;
                RaisePropertyChanged("Sources");
            }
        }
        private ObservableCollection<AlphaKeyGroups<User>> _itemSource;
        public ObservableCollection<AlphaKeyGroups<User>> ItemSource
        {
            get { return _itemSource; }
            set
            {
                _itemSource = value;
                RaisePropertyChanged("ItemSource");
            }
        }
        private ObservableCollection<Tweets> _listTweets;
        public ObservableCollection<Tweets> ListTweets
        {
            get { return _listTweets; }
            set
            {
                _listTweets = value;
                RaisePropertyChanged("ListTweets");
            }
        }
        public RelayCommand TappedCommand { get; private set; }
        private User _selectedUser;
        public User SelectedUser
        {
            get { return _selectedUser; }
            set
            {
                _selectedUser = value;
                RaisePropertyChanged("SelectedUser");
            }
        }
        private User _currentUser;
        public User CurrentUser
        {
            get { return _currentUser; }
            set
            {
                _currentUser = value;
                RaisePropertyChanged("CurrentUser");
            }
        }
        private Tweets _selectedTweet;
        public Tweets SelectedTweet
        {
            get { return _selectedTweet; }
            set
            {
                _selectedTweet = value;
                RaisePropertyChanged("SelectedTweet");
            }
        }
        private string _textTweet;
        public string TextTweet
        {
            get { return _textTweet;}
            set
            {
                _textTweet = value;
                RaisePropertyChanged("TextTweet");
            }
        }

        #endregion

        #region Ctor

        public FriendViewModel()
        {
            FollowerCommand = new RelayCommand(FollowerCommandExecute);
            TweetCommand = new RelayCommand(TweetCommandExecute);
            TappedCommand = new RelayCommand(Execute);
            LoadedCommand = new RelayCommand(UpdateFriend);
            SendTweet = new RelayCommand(SendTweetExecute);

            Sources = new ObservableCollection<User>();
            ItemSource = new ObservableCollection<AlphaKeyGroups<User>>();
            CurrentUser = Singleton.Instance().CurrentUser;

            if (_localSettings != null && (string) _localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                Sources = Singleton.Instance().CurrentUser.friends;
                ItemSource = AlphaKeyGroups<User>.CreateGroups(Sources, CultureInfo.CurrentUICulture, s => s.username,
                    true);
            }
            
            LoadTweet();
        }
        
        #endregion
    }
}