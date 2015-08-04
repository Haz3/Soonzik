using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Data;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Navigation;
using SoonZik.Models;
using SoonZik.ViewModels;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class NewsDetails : Page
    {
        public NewsDetails()
        {
            this.InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            News elem = e.Parameter as News;
            news_author.Text = elem.user.username;
            news_title.Text = elem.title;
            if (elem.newstexts.Any())
            {
                news_content.Text = elem.newstexts[0].content;
                if (elem.newstexts.Count == 2)
                   news_content2.Text = elem.newstexts[1].content;
            }

            // To get the news id
            string request_elem = "/news/" + elem.id.ToString();
            var comments = new CommentViewModel(request_elem);
            comment_lv.ItemsSource = comments.commentlist;
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }
    }
}
