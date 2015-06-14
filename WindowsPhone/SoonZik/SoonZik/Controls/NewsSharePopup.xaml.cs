using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using SoonZik.HttpRequest.Poco;
using SoonZik.ViewModel;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class NewsSharePopup : UserControl
    {
        private News _selectedNews;

        public NewsSharePopup(News theNews)
        {
            this.InitializeComponent();
            _selectedNews = theNews;
        }

        public void FacebookShare_OnTapped(object sender, TappedRoutedEventArgs e)
        {
                // TODO Share on Facebook
            NewsViewModel.MessagePrompt.Hide();
        }

        public void TwitterShare_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            // TODO Share on Twittter
            NewsViewModel.MessagePrompt.Hide();
        }
    }
}
