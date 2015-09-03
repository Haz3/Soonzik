using System.Collections.Generic;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Microsoft.Practices.ServiceLocation;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.ViewModel;
using SoonZik.Views;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class ButtonFriendPopUp : UserControl
    {
        #region ctor

        public ButtonFriendPopUp(int Id)
        {
            InitializeComponent();
            Navigation = new NavigationService();
            Friend = Id;

            var request = new HttpRequestGet();

            var test = request.GetObject(new User(), "users", Friend.ToString());
            test.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as User;
                if (res != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () => { ProfilFriendViewModel.UserFromButton = res; });
                }
            });
        }

        #endregion

        #region Attribute

        public int Friend;
        public INavigationService Navigation;

        #endregion

        #region Method

        private void SendMessage(object sender, RoutedEventArgs e)
        {
            Navigation.Navigate(typeof (Conversation));
        }

        private void GoToProfil(object sender, RoutedEventArgs e)
        {
            //    Singleton.Instance().NewProfilUser = Friend;
            //    Singleton.Instance().ItsMe = false;
            //    Singleton.Instance().Charge();
            GlobalMenuControl.MyGrid.Children.Clear();
            GlobalMenuControl.MyGrid.Children.Add(new ProfilFriendView());
            FriendViewModel.MeaagePrompt.Hide();
        }

        private void DeleteContact(object sender, RoutedEventArgs e)
        {
            AddDelFriendHelpers.GetUserKeyForFriend(Friend.ToString(), true);
            //var post = new HttpRequestPost();
            //var get = new HttpRequestGet();

            //var userKey = get.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
            //userKey.ContinueWith(delegate(Task<object> task)
            //{
            //    var key = task.Result as string;
            //    if (key != null)
            //    {
            //        var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
            //        var cryptographic = EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);
            //        DelFriend(post, cryptographic, get);
            //    }
            //});
        }

        private void DelFriend(HttpRequestPost post, string cryptographic, HttpRequestGet get)
        {
            var resPost = post.DelFriend(cryptographic, Friend.ToString(),
                Singleton.Instance().CurrentUser.id.ToString());
            resPost.ContinueWith(delegate(Task<string> tmp)
            {
                var test = tmp.Result;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        var followers = get.GetFriends(new List<User>(), "users",
                            Singleton.Instance().CurrentUser.id.ToString());
                        followers.ContinueWith(delegate(Task<object> task1)
                        {
                            var res = task1.Result as List<User>;
                            if (res != null)
                            {
                                Singleton.Instance().CurrentUser.friends.Clear();
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        foreach (var user in res)
                                        {
                                            Singleton.Instance().CurrentUser.friends.Add(user);
                                        }
                                        ServiceLocator.Current.GetInstance<FriendViewModel>().UpdateFriend();
                                        new MessageDialog("Suppression OK").ShowAsync();
                                    });
                            }
                        });
                    });
                }
            });
        }

        #endregion
    }
}