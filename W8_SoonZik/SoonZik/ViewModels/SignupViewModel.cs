using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Views;
using SoonZik.ViewModels.Command;
using System.ComponentModel;
using System.Windows.Input;
using SoonZik.Tools;
using Newtonsoft.Json.Linq;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

namespace SoonZik.ViewModels
{
    class SignupViewModel : INotifyPropertyChanged
    {
        private User _new_user;
        public User new_user
        {
            get { return _new_user; }
            set
            {
                _new_user = value;
                OnPropertyChanged("new_user");
            }
        }

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

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public ICommand do_signup
        {
            get;
            private set;
        }

        public SignupViewModel()
        {
            new_user = new User();
            new_user.address = new Address();
            do_signup = new SignupCommand(this);
        }

        // Method called in SignupCommand file
        public async void signup()
        {

            Exception exception = null;
            var request = new Http_post();

            try
            {
                //new MessageDialog("prenom = " + new_user.fname + "\nnom = " + new_user.lname, "Signup KO").ShowAsync();
                // HTTP_POST -> URL + DATA
                string user_data =
                    "&user[fname]=" + new_user.fname +
                    "&user[lname]=" + new_user.lname +
                    "&user[username]=" + new_user.username +
                    "&user[email]=" + new_user.email +
                    "&user[password]=" + passwd +
                    "&user[birthday]=" + new_user.birthday +
                    "&user[phoneNumber]=" + new_user.phoneNumber +
                    "&user[desciption]=" + new_user.description +
                    "&user[language]=" + new_user.language +
                    "&address[numberStreet]=" + new_user.address.numberStreet +
                    "&address[street]=" + new_user.address.street +
                    "&address[zipcode]=" + new_user.address.zipcode +
                    "&address[city]=" + new_user.address.city +
                    "&address[country]=" + new_user.address.country +
                    "&address[complement]=" + new_user.address.complement;

                var response = await request.post_request("users/save", user_data);

                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    await new MessageDialog("Email = " + new_user.email + "\nPassword = " + passwd, "Signup OK").ShowAsync();
                    ((Frame)Window.Current.Content).Navigate(typeof(SoonZik.Views.Connection));
                }
                else
                    await new MessageDialog("Signup KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }


            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Signup POST Error");
                await msgdlg.ShowAsync();
            }
        }
    }
}
