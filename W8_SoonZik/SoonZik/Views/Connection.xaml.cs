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
using SoonZik.ViewModels;

// Pour en savoir plus sur le modèle d'élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class Connection : Page
    {
       // ConnectionViewModel connection = new ConnectionViewModel();
        public Connection()
        {
            this.InitializeComponent();
            DataContext = new ConnectionViewModel();
        }

        private void Connect_btn_Click(object sender, RoutedEventArgs e)
        {
            
            //connection.do_classic_connection();
           this.Frame.Navigate(typeof(Home));
        }

        private void signup_txt_SelectionChanged(object sender, TappedRoutedEventArgs e)
        {
            this.Frame.Navigate(typeof(Signup));
        }
    }
}
