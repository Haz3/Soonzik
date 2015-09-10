using System;
using System.Collections.Generic;
using Windows.UI.Popups;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.ViewModel;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class NewsSharePopup : UserControl
    {
        private readonly News _selectedNews;

        public NewsSharePopup(News theNews)
        {
            InitializeComponent();
            _selectedNews = theNews;
        }

        public void FacebookShare_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            // TODO Share on Facebook

            var postParams = new
            {
                name = _selectedNews.Newstexts[0].title,
                caption = _selectedNews.Newstexts[0].content,
                description = TextBoxShare.Text,
                picture = "http://facebooksdk.net/assets/img/logo75x75.png"
            };
            ShareOnFaceBook(postParams);
        }

        private async void ShareOnFaceBook(object postParams)
        {
            if (Singleton.Instance().MyFacebookClient != null)
            {
                try
                {
                    dynamic fbPostTaskResult =
                        await Singleton.Instance().MyFacebookClient.PostTaskAsync("/me/feed", postParams);
                    var responseresult = (IDictionary<string, object>) fbPostTaskResult;
                    var SuccessMsg = new MessageDialog("Message posted sucessfully on facebook wall");
                    await SuccessMsg.ShowAsync();
                    NewsViewModel.MessagePrompt.Hide();
                }
                catch (Exception ex)
                {
                    var ErrMsg = new MessageDialog("Error Ocuured!" + ex).ShowAsync();
                }
            }
            else
            {
                var ErrMsg = new MessageDialog("Vous n'etes pas connecter a facebook").ShowAsync();
            }
        }

        public void TwitterShare_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            // TODO Share on Twittter
            NewsViewModel.MessagePrompt.Hide();
        }
    }
}