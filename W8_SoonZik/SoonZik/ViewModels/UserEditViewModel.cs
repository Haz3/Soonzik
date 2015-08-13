using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using System.Windows.Input;
using Newtonsoft.Json.Linq;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using SoonZik.ViewModels.Command;

namespace SoonZik.ViewModels
{
    class UserEditViewModel : INotifyPropertyChanged
    {
        private User _edit_user;
        public User edit_user
        {
            get { return _edit_user; }
            set
            {
                _edit_user = value;
                OnPropertyChanged("edit_user");
            }
        }

        //private User _SelectedUser;
        public User SelectedUser { get; set; }
        //{
        //    get { return _SelectedUser; }
        //    set
        //    {
        //        _SelectedUser = value;
        //        OnPropertyChanged("SelectedUser");
        //    }
        //}

        private string _passwd;
        public string passwd
        {
            get { return _passwd; }
            set
            {
                _passwd = value;
                OnPropertyChanged("passwd");
            }
        }

        private string _passwd_verif;
        public string passwd_verif
        {
            get { return _passwd_verif; }
            set
            {
                _passwd_verif = value;
                OnPropertyChanged("passwd_verif");
            }
        }

        // new friend's username
        private string _new_friend;
        public string new_friend
        {
            get { return _new_friend; }
            set
            {
                _new_friend = value;
                OnPropertyChanged("new_friend");
            }
        }

        // new follow username
        private string _new_follow;
        public string new_follow
        {
            get { return _new_follow; }
            set
            {
                _new_follow = value;
                OnPropertyChanged("new_follow");
            }
        }

        public ICommand do_add_friend
        {
            get;
            private set;
        }
        public ICommand do_remove_friend
        {
            get;
            private set;
        }
        public ICommand do_follow
        {
            get;
            private set;
        }
        public ICommand do_unfollow
        {
            get;
            private set;
        }

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public UserEditViewModel()
        {
            edit_user = Singleton.Instance.Current_user;
            do_add_friend = new AddFriendCommand(this);
            do_remove_friend = new RemoveFriendCommand(this);
            do_follow = new FollowCommand(this);
            do_unfollow = new UnfollowCommand(this);
        }

        public async void add_friend()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                var friend = await Http_get.get_user_by_username(new_friend);
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&friend_id=" + friend.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/addfriend", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Created")
                {
                    await new MessageDialog("Add friend OK").ShowAsync();
                    Singleton.Instance.Current_user.friends.Add(friend);
                }
                else
                    await new MessageDialog("Add friend KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Add friend Error").ShowAsync();
        }

        public async void follow()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                var follow = await Http_get.get_user_by_username(new_follow);
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&follow_id=" + follow.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/follow", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Created")
                {
                    await new MessageDialog("Follow OK").ShowAsync();
                    Singleton.Instance.Current_user.follows.Add(follow);

                }
                else
                    await new MessageDialog("Follow KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Follow Error").ShowAsync();
        }

        public async void remove_friend()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&friend_id=" + SelectedUser.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/delfriend", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Success")
                {
                    await new MessageDialog("Remove friend OK").ShowAsync();
                    Singleton.Instance.Current_user.friends.Remove(SelectedUser);
                }
                else
                    await new MessageDialog("Remove friend KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Remove friend Error").ShowAsync();
        }

        public async void unfollow()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&follow_id=" + SelectedUser.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/unfollow", post_data);
                var json = JObject.Parse(response).SelectToken("message");
                // Debug
                if (json.ToString() == "Success")
                {
                    await new MessageDialog("Unfollow OK").ShowAsync();
                    Singleton.Instance.Current_user.follows.Remove(SelectedUser);

                }
                else
                    await new MessageDialog("Unfollow KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Unfollow Error").ShowAsync();
        }
    }
}
