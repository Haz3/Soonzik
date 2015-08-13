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
using SoonZik.Tools;

using SoonZik.Views;

// Pour en savoir plus sur le modèle d'élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class Home : Page
    {
        public Home()
        {
            this.InitializeComponent();
            hello_tb.Text = "Salut " + Singleton.Instance.Current_user.username;
        }

        private void news_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(NewsView));
        }

        private void explorer_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Explorer));
        }

        private void concert_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Concert));
        }

        private void battle_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(battle));
        }

        private void shop_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Shop));
        }

        private void audio_player_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(music_player));
        }

        private void sign_out_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        private void profil_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(UserEditProfile));
        }

        // Clic in list
        private void News_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.News)e.ClickedItem);
            this.Frame.Navigate(typeof(NewsDetails), item);
        }

        private void Music_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Album)e.ClickedItem);
            this.Frame.Navigate(typeof(Album), item);
        }
        // END
    }
}
