﻿using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;

namespace SoonZik.ViewModels
{
    class UserViewModel : INotifyPropertyChanged
    {
        private User _user;
        public User user
        {
            get { return _user; }
            set
            {
                _user = value;
                OnPropertyChanged("user");
            }
        }

        static public ObservableCollection<User> friends { get; set; }
        static public ObservableCollection<User> follows { get; set; }

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


        private Visibility _add_friend_btn;
        public Visibility add_friend_btn
        {
            get { return _add_friend_btn; }
            set
            {
                _add_friend_btn = value;
                OnPropertyChanged("add_friend_btn");
            }
        }

        private Visibility _remove_friend_btn;
        public Visibility remove_friend_btn
        {
            get { return _remove_friend_btn; }
            set
            {
                _remove_friend_btn = value;
                OnPropertyChanged("remove_friend_btn");
            }
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

        public UserViewModel(int id)
        {
            add_friend_btn = Visibility.Visible;
            remove_friend_btn = Visibility.Visible;
            do_add_friend = new RelayCommand(add_friend);
            do_remove_friend = new RelayCommand(remove_friend);

            load_user(id);

            get_friends(id);
            get_follows(id);




        }

        public async void load_user(int id)
        {
             Exception exception = null;

            try
            {
                user = await Http_get.get_user_by_id(id.ToString());

            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "user error").ShowAsync();
        }

        public async void get_friends(int id)
        {
            Exception exception = null;
            friends = new ObservableCollection<User>();

            try
            {
                var list = (List<User>)await Http_get.get_object(new List<User>(), "users/" + id.ToString() + "/friends");

                foreach (var item in list)
                    friends.Add(item);

                if (friends.Any(x=> x.username == Singleton.Instance.Current_user.username))
                    add_friend_btn = Visibility.Collapsed;
                else
                    remove_friend_btn = Visibility.Collapsed;
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "get friends error").ShowAsync();
        }

        async public void get_follows(int id)
        {
            Exception exception = null;
            follows = new ObservableCollection<User>();

            try
            {
                var list = (List<User>)await Http_get.get_object(new List<User>(), "users/" + id.ToString() + "/follows");

                foreach (var item in list)
                    follows.Add(item);
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "get follows error").ShowAsync();
        }

        public async void add_friend()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                var friend = await Http_get.get_user_by_id(user.id.ToString());
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
                    Singleton.Instance.Current_user.friends.Add(user);
                    add_friend_btn = Visibility.Collapsed;
                    remove_friend_btn = Visibility.Visible;
                    friends.Add(Singleton.Instance.Current_user);
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

        public async void remove_friend()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&friend_id=" + user.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("users/delfriend", post_data);

                var json = JObject.Parse(response).SelectToken("message");

                // Debug
                if (json.ToString() == "Success")
                {
                    await new MessageDialog("Remove friend OK").ShowAsync();
                    Singleton.Instance.Current_user.friends.Remove(user);
                    add_friend_btn = Visibility.Visible;
                    remove_friend_btn = Visibility.Collapsed;
                    friends.Remove(Singleton.Instance.Current_user);
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
    }
}
