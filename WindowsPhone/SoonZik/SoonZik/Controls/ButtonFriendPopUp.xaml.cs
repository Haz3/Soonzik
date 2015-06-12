using System.Threading.Tasks;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using SoonZik.Utils;
using SoonZik.Views;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class ButtonFriendPopUp : UserControl
    {

        #region Attribute

        public int Friend;
        public INavigationService Navigation;
        #endregion

        #region ctor
        public ButtonFriendPopUp(int Id)
        {
            this.InitializeComponent();
            Navigation = new NavigationService();
            Friend = Id;
        }
        #endregion

        #region Method
        private void SendMessage(object sender, RoutedEventArgs e)
        {

            Navigation.Navigate(typeof(Conversation));
        }

        private void GoToProfil(object sender, RoutedEventArgs e)
        {
            Singleton.Instance().NewProfilUser = Friend;
            Singleton.Instance().ItsMe = false;
            var task = Task.Run(async () => await Singleton.Instance().Charge());
            task.Wait();
            Navigation.Navigate(typeof(ProfilUser));
        }

        private void DeleteContact(object sender, RoutedEventArgs e)
        {

        }
        #endregion
    }
}
