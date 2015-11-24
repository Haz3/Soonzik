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
    class MusicViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<Music> musiclist { get; set; }

        // LIKE THAT CAUSE I DID NOT INSTANTIATE THEM IN LOAD_MUSIC i think ...
        private ObservableCollection<Comment> _commentlist;
        public ObservableCollection<Comment> commentlist
        {
            get { return _commentlist; }
            set
            {
                _commentlist = value;
                OnPropertyChanged("commentlist");
            }
        }

        private Music _music;
        public Music music
        {
            get { return _music; }
            set
            {
                _music = value;
                OnPropertyChanged("music");
            }
        }

        private string _comment_content;
        public string comment_content
        {
            get { return _comment_content; }
            set
            {
                _comment_content = value;
                OnPropertyChanged("comment_content");
            }
        }

        public ICommand do_send_comment
        {
            get;
            private set;
        }

        public ICommand do_add_to_cart
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

        public MusicViewModel(int id)
        {
            do_send_comment = new RelayCommand(send_comment);
            do_add_to_cart = new RelayCommand(add_to_cart);
            load_music(id);
        }

        public MusicViewModel()
        {
            load_musics();
        }

        async void load_music(int id)
        {
            Exception exception = null;

            try
            {
                // Load the news
                music = await Http_get.get_music_by_id(id);

                var comment_vm = await CommentViewModel.load_comments("/musics/" + music.id.ToString());
                commentlist = comment_vm;
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Music error").ShowAsync();
        }

        async public void send_comment()
        {
            if (await CommentViewModel.send_comment(comment_content, "musics", music.id.ToString()))
            {
                // New comment to add in the observable collection in order to refresh the list ...
                var new_comment = new Comment();
                new_comment.user = Singleton.Instance.Current_user;
                new_comment.content = comment_content;
                commentlist.Insert(0, new_comment);
                // To delete text in comment bar
                comment_content = "";
            }
        }

        async void load_musics()
        {
            Exception exception = null;
            musiclist = new ObservableCollection<Music>();

            try
            {
                var musics = (List<Music>)await Http_get.get_object(new List<Music>(), "musics");

                foreach (var item in musics)
                    musiclist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Music error").ShowAsync();
        }

        public void add_to_cart()
        {
            //                        USER ID,                            ALBUM ID,   TYPE,  GIFT USER ID (IF < 0 : NOT A GIFT)
            CartViewModel.add_to_cart(Singleton.Instance.Current_user.id, music.id, "Music", 0);
        }

        async public void set_note(int note)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string url = "/musics/" + music.id.ToString() + "/note/" + note.ToString();
                string data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());


                // HTTP_POST -> URL + DATA
                var response = await request.post_request(url, data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                    await new MessageDialog("note OK").ShowAsync();
                else
                    await new MessageDialog("note KO").ShowAsync();

            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Note POST error").ShowAsync();
        }
    }
}
