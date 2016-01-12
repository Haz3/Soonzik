using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class PlayerViewmodel : INotifyPropertyChanged
    {
        //
        // http://api.lvh.me:3000/playlists/save?playlist[user_id]=4&playlist[name]=playlist_one&playlist[music]=[1,2,3,4,5,6]&user_id=4&secureKey=01b5c4e0ff4bae98d3f31d5285ad9799b4d7068f40e800cc010dbea456f8a227

        //
        // http://api.lvh.me:3000/playlists/update?playlist[user_id]=4&playlist[name]=playlist_one&playlist[music]=[1,2,3,4,5,6]&user_id=4&secureKey=01b5c4e0ff4bae98d3f31d5285ad9799b4d7068f40e800cc010dbea456f8a227


        public ObservableCollection<Playlist> playlist_list { get; set; }

        private Playlist _selected_playlit;
        public Playlist selected_playlist
        {
            get { return _selected_playlit; }
            set
            {
                _selected_playlit = value;
                OnPropertyChanged("selected_playlist");
            }
        }


        private Album _selected_album;
        public Album selected_album
        {
            get { return _selected_album; }
            set
            {
                _selected_album = value;
                OnPropertyChanged("selected_album");
            }
        }

        private Music _selected_music;
        public Music selected_music
        {
            get { return _selected_music; }
            set
            {
                _selected_music = value;
                OnPropertyChanged("selected_music");
            }
        }

        private MusicOwnByUser _music_own;
        public MusicOwnByUser music_own
        {
            get { return _music_own; }
            set
            {
                _music_own = value;
                OnPropertyChanged("music_own");
            }
        }

        private List<Music> _music_list_to_add;
        public List<Music> music_list_to_add
        {
            get { return _music_list_to_add; }
            set
            {
                _music_list_to_add = value;
                OnPropertyChanged("music_list_to_add");
            }
        }

        private string _playlist_name;
        public string playlist_name
        {
            get { return _playlist_name; }
            set
            {
                _playlist_name = value;
                OnPropertyChanged("playlist_name");
            }
        }

        public ICommand do_create_playlist
        {
            get;
            private set;
        }

        public ICommand do_delete_playlist
        {
            get;
            private set;
        }

        public ICommand do_add_to_playlist
        {
            get;
            private set;
        }

        public ICommand do_remove_to_playlist
        {
            get;
            private set;
        }



        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }


        public PlayerViewmodel()
        {
            music_list_to_add = new List<Music>();
            playlist_list = new ObservableCollection<Playlist>();


            load_music_own();
            load_playlist();

            // load playlist
            // relay command les buttons
            do_create_playlist = new RelayCommand(create_playlist);
            do_delete_playlist = new RelayCommand(delete_playlist);
            do_add_to_playlist = new RelayCommand(add_to_playlist);



            // voila
        }

        async void load_music_own()
        {
            Exception exception = null;
            music_own = new MusicOwnByUser();

            try
            {
                music_own = (MusicOwnByUser)await Http_get.get_object(new MusicOwnByUser(), "/users/getmusics?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la récupération de la musique de l'utilisateur").ShowAsync();
        }

        async void load_playlist()
        {
            Exception exception = null;
            // ici new observable avant
            try
            {
                var playlists = (List<Playlist>)await Http_get.get_object(new List<Playlist>(), "/playlists/find?attribute[user_id]=" + Singleton.Instance.Current_user.id.ToString());


                foreach (var item in playlists)
                    playlist_list.Add(item);


            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la récupération des playlists de l'utilisateur").ShowAsync();
        }

        async void create_playlist()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                if (playlist_name == null || playlist_name == "")
                {
                    await new MessageDialog("Entrez un nom de playlist").ShowAsync();
                    return;
                }
                if (playlist_name.Length < 4)
                {
                    await new MessageDialog("Le nom de la playlist est trop court").ShowAsync();
                    return;
                }

                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&playlist[user_id]=" + Singleton.Instance.Current_user.id.ToString() +
                    "&playlist[name]=" + playlist_name;

                var response = await request.post_request("/playlists/save", data);

                // to get the id of the new playlist
                dynamic json = JObject.Parse(response).SelectToken("content");

                // get ids
                string musics_id = "";
                foreach (var music in music_list_to_add)
                    musics_id += music.id.ToString() + ",";


                var data_update =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&id=" + json.id +
                    "&playlist[user_id]=" + Singleton.Instance.Current_user.id.ToString() +
                    "&playlist[name]=" + playlist_name +
                    "&playlist[music]=[" + musics_id.Remove(musics_id.Length - 1) + "]";

                var response_update = await request.post_request("/playlists/update", data_update);

                var jsonbis = JObject.Parse(response_update).SelectToken("message");

                if (jsonbis.ToString() == "Created")
                    await new MessageDialog("Playlist créée avec succès").ShowAsync();
                else
                    await new MessageDialog("Erreur lors de la création de la playlist").ShowAsync();


                // clean music list & name
                music_list_to_add.Clear();
                playlist_name = "";

                // reload playlist list
                playlist_list.Clear();
                load_playlist();

            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la création de la playlist").ShowAsync();

        }

        void add_to_playlist()
        {
            if (selected_music != null)
                _music_list_to_add.Add(selected_music);
        }

        async void delete_playlist()
        {

        }

    }
}
