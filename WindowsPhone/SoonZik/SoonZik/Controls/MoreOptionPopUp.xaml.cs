using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Newtonsoft.Json.Linq;
using SoonZik.Annotations;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.ViewModel;
using SoonZik.Views;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class MoreOptionPopUp : UserControl, INotifyPropertyChanged
    {
        #region Ctor

        public MoreOptionPopUp(Music theMusic)
        {
            InitializeComponent();
            SelectedMusic = theMusic;
            TitleBlock.Text = SelectedMusic.title;
        }

        #endregion

        #region Attribute

        public static readonly DependencyProperty SelectedMusicProperty = DependencyProperty.Register(
            "SelectedMusic", typeof(Music), typeof(MoreOptionPopUp), new PropertyMetadata(default(Music)));

        public Music SelectedMusic
        {
            get { return (Music)GetValue(SelectedMusicProperty); }
            set { SetValue(SelectedMusicProperty, value); }
        }

        private Music _selectedMusic { get; set; }

        private string _cryptographic { get; set; }

        public static Playlist ThePlaylist { get; set; }
        #endregion

        #region INotifyPropertyChange

        public event PropertyChangedEventHandler PropertyChanged;

        [NotifyPropertyChangedInvocator]
        private void RaisePropertyChange([CallerMemberName] string propertyName = null)
        {
            var handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }

        #endregion

        #region Method

        private void AddToPlaylist(object sender, RoutedEventArgs e)
        {
            MyMusicViewModel.MusicForPlaylist = SelectedMusic;
            MyMusicViewModel.IndexForPlaylist = 3;
            GlobalMenuControl.SetChildren(new MyMusic());
            AlbumViewModel.MessagePrompt.Hide();
        }

        private void AddToCard(object sender, RoutedEventArgs e)
        {
            _selectedMusic = SelectedMusic;
            var request = new HttpRequestGet();
            var post = new HttpRequestPost();
            _cryptographic = "";
            var userKey2 = request.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
            userKey2.ContinueWith(delegate(Task<object> task2)
            {
                var key2 = task2.Result as string;
                if (key2 != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key2);
                    _cryptographic = EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);
                }
                var res = post.SaveCart(_selectedMusic, null, _cryptographic, Singleton.Instance().CurrentUser);
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var res2 = tmp2.Result;
                    if (res2 != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                        {
                            new MessageDialog("Article ajoute au panier").ShowAsync();
                            AlbumViewModel.MessagePrompt.Hide();
                        });
                    }
                });
            });
        }

        private void DelFromPlaylist(object sender, RoutedEventArgs e)
        {
            if (ThePlaylist != null)
            {
                _selectedMusic = SelectedMusic;
                var request = new HttpRequestGet();
                var userKey = request.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
                userKey.ContinueWith(delegate(Task<object> task)
                {
                    var _key = task.Result as string;
                    if (_key != null)
                    {
                        var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(_key);
                        _cryptographic = EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);

                        var resDel = request.DeleteMusicFromPlaylist(ThePlaylist, _selectedMusic, _cryptographic, Singleton.Instance().CurrentUser);

                        resDel.ContinueWith(delegate(Task<string> tmp)
                        {
                            var test = tmp.Result;
                            if (test != null)
                            {
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        var stringJson = JObject.Parse(test).SelectToken("code").ToString();
                                        if (stringJson == "200")
                                        {
                                            new MessageDialog("Music delete").ShowAsync();
                                            PlaylistViewModel.UpdatePlaylist.Execute(null);
                                            PlaylistViewModel.MessagePrompt.Hide();
                                        }
                                        else
                                        {
                                            new MessageDialog("Delete Fail code: " + stringJson).ShowAsync();
                                            PlaylistViewModel.MessagePrompt.Hide();
                                        }
                                    });
                            }
                        });
                    }
                });
            }
            else
            {
                new MessageDialog("You need to be on the playlist").ShowAsync();
            }
        }
        #endregion
    }
}