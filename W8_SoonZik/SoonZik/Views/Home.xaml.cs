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

// Pour en savoir plus sur le modèle d'élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class Home : Page
    {
        public Home()
        {
            this.InitializeComponent();
        }

        private void news_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(News));
        }

        private void shop_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Shop));
        }

        private void community_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Community));
        }

        private void audio_player_btn_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(music_player));
        }
    }
}
