using System;
using System.Windows;
using System.Windows.Controls;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SonnZik.Streaming.HttpWebRequest;
using SonnZik.Streaming.HttpWebRequest.Poco;

namespace SoonZik.Streaming.View
{
    /// <summary>
    /// Logique d'interaction pour Connexion.xaml
    /// </summary>
    public partial class Connexion : UserControl
    {
        #region Attribute
        private string _username { get; set; }
        private string _password { get; set; }
        #endregion

        #region ctor
        public Connexion()
        {
            InitializeComponent();
        }

        #endregion

        #region Method
        private void ConnexionButton_OnClick(object sender, RoutedEventArgs e)
        {
            _username = UserNameTecBox.Text;
            _password = PassWordTextBox.Password;

            if (_username != String.Empty && _password != String.Empty)
            {
                MakeConnexion();
            }
            else
            {
                MessageBoxResult result = MessageBox.Show("Veuillez renseigner les champs", "Erreur");
            }
        }

        private async void MakeConnexion()
        {
            var connec = new HttpWebRequestPost();
            await connec.ConnexionSimple(_username, _password);
            var res = connec.Received;
            GetUser(res);
            MainWindow.ConnectionWindow.Close();
        }

        private void GetUser(string res)
        {
            if (res != null)
            {
                try
                {
                    var stringJson = JObject.Parse(res).SelectToken("content").ToString();
                    Singleton.Singleton.Instance().TheArtiste =
                        JsonConvert.DeserializeObject(stringJson, typeof(User)) as User;
                }
                catch (Exception e)
                {
                    MessageBoxResult result = MessageBox.Show("Erreur de connexion", "Erreur");
                }
            }
        }
        #endregion
    }
}
