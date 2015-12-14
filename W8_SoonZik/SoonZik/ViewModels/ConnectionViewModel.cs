using Newtonsoft.Json.Linq;
using SoonZik.Tools;
using SoonZik.ViewModels.Command;
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
using Facebook;
using Windows.Security.Authentication.Web;
using System.Dynamic;
using SoonZik.Common;

namespace SoonZik.ViewModels
{
    public class ConnectionViewModel : INotifyPropertyChanged
    {
        // FACEBOOK STUFF
        string AppId = "1663237633911112";
        private const string _permissions = "user_about_me";
        FacebookClient _fb = new FacebookClient();


        // CLASSIC STUFF
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

        //public bool canUpdate
        //{
        //    get
        //    {
        //        if (mail == null && passwd == null)
        //            return false;
        //        return true;
        //    }
        //}

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

        public ICommand do_facebook_connection
        {
            get;
            private set;
        }

        public ConnectionViewModel()
        {
            // Dev only
            mail = "user_four@gmail.com";
            passwd = "azertyuiop";
            do_classic_connection = new ConnectionCommand(this);
            do_facebook_connection = new RelayCommand(facebook_connection);
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
                    //await new MessageDialog("Email = " + mail + "\nPasswd = " + passwd, "Connexion OK").ShowAsync();
                    ((Frame)Window.Current.Content).Navigate(typeof(SoonZik.Views.Home));
                }
                else
                    await new MessageDialog("Connexion KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
               await new MessageDialog(exception.Message, "Connection POST Error").ShowAsync();
        }

        void Get_User(string response)
        {
            User Current_User = new User();

            var json = JObject.Parse(response).SelectToken("content").ToString();
            Current_User = JsonConvert.DeserializeObject(json, typeof(User)) as User;

            // Singleton CALL
            Singleton.Instance.Current_user = Current_User;

            Singleton.Instance.compare_date = new DateTime();
        }

        public async void facebook_connection()
        {
            var redirectUrl = "https://www.facebook.com/connect/login_success.html";
            try
            {
                //fb.AppId = facebookAppId;
                var loginUrl = _fb.GetLoginUrl(new
                {
                    client_id = AppId,
                    redirect_uri = redirectUrl,
                    scope = _permissions,
                    display = "popup",
                    response_type = "token"
                });

                var endUri = new Uri(redirectUrl);

                WebAuthenticationResult WebAuthenticationResult = await WebAuthenticationBroker.AuthenticateAsync(
                                                        WebAuthenticationOptions.None,
                                                        loginUrl,
                                                        endUri);
                if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.Success)
                {
                    var callbackUri = new Uri(WebAuthenticationResult.ResponseData.ToString());
                    var facebookOAuthResult = _fb.ParseOAuthCallbackUrl(callbackUri);
                    var accessToken = facebookOAuthResult.AccessToken;
                    if (String.IsNullOrEmpty(accessToken))
                    {
                        // User is not logged in, they may have canceled the login
                    }
                    else
                    {
                        // User is logged in and token was returned
                        facebook_LoginSucceded(accessToken);
                    }

                }
                else if (WebAuthenticationResult.ResponseStatus == WebAuthenticationStatus.ErrorHttp)
                {
                    throw new InvalidOperationException("HTTP Error returned by AuthenticateAsync() : " + WebAuthenticationResult.ResponseErrorDetail.ToString());
                }
                else
                {
                    // The user canceled the authentication
                }
            }
            catch (Exception ex)
            {
                //
                // Bad Parameter, SSL/TLS Errors and Network Unavailable errors are to be handled here.
                //
               // throw ex;

                 new MessageDialog("Erreur de connexion avec Facebook").ShowAsync();

            }
        }
        private async void facebook_LoginSucceded(string accessToken)
        {
            dynamic parameters = new ExpandoObject();
            parameters.access_token = accessToken;
            parameters.fields = "id";

            dynamic result = await _fb.GetTaskAsync("me", parameters);
            parameters = new ExpandoObject();
            parameters.id = result.id;
            parameters.access_token = accessToken;

            // Store info... useless ??? yeah ...
            Singleton.Instance.fb_id = result.id;
            Singleton.Instance.fb_token = accessToken;

            // CALL social login
            social_connection("facebook");
        }


        // SOCIAL LOGIN

        public async void social_connection(string sn)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string social_token = await Security.getSocialToken(Singleton.Instance.fb_id, sn);
                string encrypted_key = Security.getSocialSecureKey(Singleton.Instance.fb_id, social_token);

                var response = await request.post_request("social-login", "uid=" + Singleton.Instance.fb_id + "&provider=" + sn + "&encrypted_key=" + encrypted_key + "&token=" + Singleton.Instance.fb_token);
                var json = JObject.Parse(response).SelectToken("content");

                if (json.ToString() != null)
                {
                    Get_User(response);
                    //await new MessageDialog("Connexion Social OK").ShowAsync();
                    ((Frame)Window.Current.Content).Navigate(typeof(SoonZik.Views.Home));
                }
                else
                    await new MessageDialog("Connexion Social KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Connexion Social POST Error").ShowAsync();
        }
    }
}
