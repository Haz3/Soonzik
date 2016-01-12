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
using Windows.Media.Playlists;
using Windows.Storage;
using Windows.Storage.Pickers;
using SoonZik;
using SoonZik.ViewModels;


// Pour en savoir plus sur le modèle d'élément Page vierge, consultez la page http://go.microsoft.com/fwlink/?LinkId=234238

namespace SoonZik
{
    /// <summary>
    /// Une page vide peut être utilisée seule ou constituer une page de destination au sein d'un frame.
    /// </summary>
    public sealed partial class music_player : Page
    {
        public music_player()
        {
            this.InitializeComponent();
            DataContext = new PlayerViewmodel();

            album_list_lv.Visibility = Visibility.Collapsed;
            track_list_lv.Visibility = Visibility.Collapsed;
            add_to_playlist_btn.Visibility = Visibility.Collapsed;
            create_playlist_btn.Visibility = Visibility.Collapsed;
            playlist_name_tb.Visibility = Visibility.Collapsed;

        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.Frame.GoBack();
        }

        async void new_playlist_btn_Click(object sender, RoutedEventArgs e)
        {

            album_list_lv.Visibility = Visibility.Visible;
            track_list_lv.Visibility = Visibility.Visible;
            add_to_playlist_btn.Visibility = Visibility.Visible;
            create_playlist_btn.Visibility = Visibility.Visible;
            playlist_name_tb.Visibility = Visibility.Visible;




           // FileOpenPicker openPicker = new FileOpenPicker();
            
           // openPicker.SuggestedStartLocation = PickerLocationId.Desktop;
           // openPicker.FileTypeFilter.Add(".mp3");
           // openPicker.FileTypeFilter.Add(".flac");
           // openPicker.FileTypeFilter.Add(".wma");
           // openPicker.FileTypeFilter.Add(".aac");
           // IReadOnlyList<StorageFile> files = await openPicker.PickMultipleFilesAsync();
            
           //if (files != null && files.Count > 0)
           //{
           //    Playlist playlist = new Playlist();

           //    foreach (StorageFile file in files)
           //    {
           //        playlist.Files.Add(file);
           //    }
           //    StorageFile savedFile = await playlist.SaveAsAsync(KnownFolders.MusicLibrary, "Sample", NameCollisionOption.ReplaceExisting, PlaylistFormat.WindowsMedia);
           //}
        }

        private void create_playlist_btn_Click(object sender, RoutedEventArgs e)
        {
            album_list_lv.Visibility = Visibility.Collapsed;
            track_list_lv.Visibility = Visibility.Collapsed;
            add_to_playlist_btn.Visibility = Visibility.Collapsed;
            create_playlist_btn.Visibility = Visibility.Collapsed;
            playlist_name_tb.Visibility = Visibility.Collapsed;
        }
    }
}
