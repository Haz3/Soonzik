﻿using System;
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

namespace SoonZik.Views
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class battle : Page
    {
        public battle()
        {
            this.InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }
        private void Artist_one_Button_Click(object sender, RoutedEventArgs e)
        {
            var msg = new Windows.UI.Popups.MessageDialog(
            "Vote pour artist 1");
            //msg.ShowAsync();
        }
        private void Artist_two_Button_Click(object sender, RoutedEventArgs e)
        {
            var msg = new Windows.UI.Popups.MessageDialog(
            "Vote pour artist 2");
            //msg.ShowAsync();
        }
    }
}
