﻿

#pragma checksum "C:\Users\Julien\Documents\Visual Studio 2013\Projects\SoonZik - Copie\SoonZik\Views\Music_player.xaml" "{406ea660-64cf-4c82-b6f0-42d48172a799}" "6001CA567080D9426A7A9139958A458A"
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace SoonZik
{
    partial class music_player : global::Windows.UI.Xaml.Controls.Page
    {
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Grid Audio_player; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Grid Data; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Grid Buttons_grid; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.ListView Playlist; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button new_playlist_btn; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button add_playlist_btn; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button remove_playlist_btn; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.ListView playlist_lv; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.TextBlock playlist_txt; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button btn_play; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button btn_stop; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button btn_previous; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button btn_next; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button btn_volume; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button btn_mute; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.TextBlock Title; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.StackPanel tb_artist; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.StackPanel album_sp; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.StackPanel year_sp; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.TextBlock music_player_txt; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private global::Windows.UI.Xaml.Controls.Button back_btn; 
        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        private bool _contentLoaded;

        [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.Windows.UI.Xaml.Build.Tasks"," 4.0.0.0")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        public void InitializeComponent()
        {
            if (_contentLoaded)
                return;

            _contentLoaded = true;
            global::Windows.UI.Xaml.Application.LoadComponent(this, new global::System.Uri("ms-appx:///Views/Music_player.xaml"), global::Windows.UI.Xaml.Controls.Primitives.ComponentResourceLocation.Application);
 
            Audio_player = (global::Windows.UI.Xaml.Controls.Grid)this.FindName("Audio_player");
            Data = (global::Windows.UI.Xaml.Controls.Grid)this.FindName("Data");
            Buttons_grid = (global::Windows.UI.Xaml.Controls.Grid)this.FindName("Buttons_grid");
            Playlist = (global::Windows.UI.Xaml.Controls.ListView)this.FindName("Playlist");
            new_playlist_btn = (global::Windows.UI.Xaml.Controls.Button)this.FindName("new_playlist_btn");
            add_playlist_btn = (global::Windows.UI.Xaml.Controls.Button)this.FindName("add_playlist_btn");
            remove_playlist_btn = (global::Windows.UI.Xaml.Controls.Button)this.FindName("remove_playlist_btn");
            playlist_lv = (global::Windows.UI.Xaml.Controls.ListView)this.FindName("playlist_lv");
            playlist_txt = (global::Windows.UI.Xaml.Controls.TextBlock)this.FindName("playlist_txt");
            btn_play = (global::Windows.UI.Xaml.Controls.Button)this.FindName("btn_play");
            btn_stop = (global::Windows.UI.Xaml.Controls.Button)this.FindName("btn_stop");
            btn_previous = (global::Windows.UI.Xaml.Controls.Button)this.FindName("btn_previous");
            btn_next = (global::Windows.UI.Xaml.Controls.Button)this.FindName("btn_next");
            btn_volume = (global::Windows.UI.Xaml.Controls.Button)this.FindName("btn_volume");
            btn_mute = (global::Windows.UI.Xaml.Controls.Button)this.FindName("btn_mute");
            Title = (global::Windows.UI.Xaml.Controls.TextBlock)this.FindName("Title");
            tb_artist = (global::Windows.UI.Xaml.Controls.StackPanel)this.FindName("tb_artist");
            album_sp = (global::Windows.UI.Xaml.Controls.StackPanel)this.FindName("album_sp");
            year_sp = (global::Windows.UI.Xaml.Controls.StackPanel)this.FindName("year_sp");
            music_player_txt = (global::Windows.UI.Xaml.Controls.TextBlock)this.FindName("music_player_txt");
            back_btn = (global::Windows.UI.Xaml.Controls.Button)this.FindName("back_btn");
        }
    }
}


