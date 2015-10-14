using System.Collections.Generic;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Microsoft.Practices.ServiceLocation;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.ViewModel;

namespace SoonZik.Utils
{
    public class AddDelFriendHelpers
    {
        public static void GetUserKeyForFriend(string id, bool friend)
        {
            var post = new HttpRequestPost();
            var get = new HttpRequestGet();

            var userKey = get.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                var key = task.Result as string;
                if (key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                    var cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
                                                            stringEncrypt);
                    if (!friend)
                        AddFriend(post, cryptographic, get, id);
                    else
                        DelFriend(post, cryptographic, get, id);
                }
            });
        }

        private static void DelFriend(HttpRequestPost post, string cryptographic, HttpRequestGet get, string id)
        {
            var resPost = post.DelFriend(cryptographic, id, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            resPost.ContinueWith(delegate(Task<string> tmp)
            {
                var res = tmp.Result;
                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                {
                    var followers = get.GetFriends(new List<User>(), "users",
                        Singleton.Singleton.Instance().CurrentUser.id.ToString());
                    followers.ContinueWith(delegate(Task<object> task1)
                    {
                        var res2 = task1.Result as List<User>;
                        if (res2 != null)
                        {
                            Singleton.Singleton.Instance().CurrentUser.friends.Clear();
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () =>
                                {
                                    foreach (var user in res2)
                                    {
                                        Singleton.Singleton.Instance().CurrentUser.friends.Add(user);
                                    }
                                    ServiceLocator.Current.GetInstance<MyNetworkViewModel>().UpdateFriend();
                                    new MessageDialog("Supr effectue").ShowAsync();
                                });
                        }
                    });
                });
            });
        }

        private static void AddFriend(HttpRequestPost post, string cryptographic, HttpRequestGet get, string id)
        {
            var resPost = post.AddFriend(cryptographic, id, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            resPost.ContinueWith(delegate(Task<string> tmp)
            {
                var test = tmp.Result;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        var followers = get.GetFriends(new List<User>(), "users",
                            Singleton.Singleton.Instance().CurrentUser.id.ToString());
                        followers.ContinueWith(delegate(Task<object> task1)
                        {
                            var res = task1.Result as List<User>;
                            if (res != null)
                            {
                                Singleton.Singleton.Instance().CurrentUser.friends.Clear();
                                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                    () =>
                                    {
                                        foreach (var user in res)
                                        {
                                            Singleton.Singleton.Instance().CurrentUser.friends.Add(user);
                                        }
                                        ServiceLocator.Current.GetInstance<MyNetworkViewModel>().UpdateFriend();
                                        new MessageDialog("Demande effectue").ShowAsync();
                                    });
                            }
                        });
                    });
                }
            });
        }
    }
}