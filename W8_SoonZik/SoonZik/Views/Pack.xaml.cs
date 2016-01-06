﻿using SoonZik.ViewModels;
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

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class Pack : Page
    {
        int old_asso_value = 20;
        int old_artist_value = 60;
        int old_website_value = 15;

        public Pack()
        {
            this.InitializeComponent();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            SoonZik.Models.Pack elem = e.Parameter as SoonZik.Models.Pack;
            DataContext = new PackViewModel(elem.id);
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        private void pack_album_listview_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Album)e.ClickedItem);
            this.Frame.Navigate(typeof(Album), item);
        }

        private void artist_bar_ValueChanged(object sender, RangeBaseValueChangedEventArgs e)
        {
            association_bar.Value = (100 - artist_bar.Value) / ((old_website_value / old_asso_value) + 1);
            website_bar.Value = (100 - artist_bar.Value) / ((old_asso_value / old_website_value) + 1);

        }

        private void association_bar_ValueChanged(object sender, RangeBaseValueChangedEventArgs e)
        {
            artist_bar.Value = (100 - association_bar.Value) / ((old_website_value / old_artist_value) + 1);
            website_bar.Value = (100 - association_bar.Value) / ((old_artist_value / old_website_value) + 1);
        }

        private void website_bar_ValueChanged(object sender, RangeBaseValueChangedEventArgs e)
        {
            //artist_bar.Value = (100 - website_bar.Value) / ((old_asso_value / old_artist_value) + 1);
            //association_bar.Value = (100 - website_bar.Value) / ((old_artist_value / old_asso_value) + 1);

        }


    }
}
