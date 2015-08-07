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
using SoonZik.Models;
using SoonZik.ViewModels;
using SoonZik.Tools;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik.Views
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class Album : Page
    {
        public Album()
        {
            this.InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            SoonZik.Models.Album elem = e.Parameter as SoonZik.Models.Album;
            album_artist.Text = elem.user.username;
            album_title.Text = elem.title;
            album_year.Text = elem.yearProd.ToString();
            album_price.Text = elem.price.ToString();
            album_music_listview.ItemsSource = elem.musics;
            album_id_tb.Text = elem.id.ToString();

            string request_elem = "/albums/" + elem.id.ToString();

            // To get comment list
            var comments = new CommentViewModel(request_elem);
            comment_lv.ItemsSource = comments.commentlist;
        }

        private void send_com_btn_Click(object sender, RoutedEventArgs e)
        {
            string comment_content = send_com_tb.Text;
            Post_comment com = new Post_comment(comment_content, "albums", album_id_tb.Text);
        }

        private void album_music_listview_ItemClick(object sender, ItemClickEventArgs e)
        {
            var item = ((SoonZik.Models.Music)e.ClickedItem);
            this.Frame.Navigate(typeof(Music), item);
        }
    }
}