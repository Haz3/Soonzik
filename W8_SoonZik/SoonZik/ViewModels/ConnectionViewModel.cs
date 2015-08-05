using Newtonsoft.Json.Linq;
using SoonZik.Tools;
using SoonZik.ViewModels.Command;
using SoonZik.Views;
using SoonZik.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Newtonsoft.Json;

namespace SoonZik.ViewModels
{
    public class ConnectionViewModel : INotifyPropertyChanged
    {
        private string _mail;
        public string mail
        {
            get { return _mail; }
            set
            {
                _mail = value;
                OnPropertyChanged("mail");
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

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        // Command bind to the xaml button
        public ICommand do_classic_connection
        {
            get;
            private set;
        }

        public ConnectionViewModel()
        {
            mail = "";
            passwd = "";
            do_classic_connection = new ConnectionCommand(this);
        }

        // Method called in the ConnectionCommand file
        public async void classic_connection()
        {

            Exception exception = null;
            var request = new Http_post();

            try
            {
                // HTTP_POST -> URL + DATA
                var response = await request.post_request("login", "email=" + mail + "&password=" + passwd);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Success")
                {
                    Get_User(response);
                    await new MessageDialog("Email = " + mail + "\nPasswd = " + passwd, "Connexion OK").ShowAsync();
                    ((Frame)Window.Current.Content).Navigate(typeof(Home));
                }
                else
                   await new MessageDialog("Connexion KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }


            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Connection POST Error");
                await msgdlg.ShowAsync();
            }
        }

        void Get_User(string response)
        {
            User Current_User = new User();

            var json = JObject.Parse(response).SelectToken("content").ToString();
            Current_User = JsonConvert.DeserializeObject(json, typeof(User)) as User;

            // Singleton CALL
            Singleton.Instance.Current_user = Current_User;
        }
    }
}
