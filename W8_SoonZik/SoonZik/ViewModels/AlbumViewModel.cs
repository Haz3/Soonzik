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
using Windows.Data.Xml.Dom;
using Windows.UI.Notifications;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class AlbumViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<Album> albumlist { get; set; }

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

        private Album _album;
        public Album album
        {
            get { return _album; }
            set
            {
                _album = value;
                OnPropertyChanged("album");
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

        public AlbumViewModel()
        {
            load_albums();
        }

        public AlbumViewModel(int id)
        {
            //commentlist = new ObservableCollection<Comment>();
            do_send_comment = new RelayCommand(send_comment);
            do_add_to_cart = new RelayCommand(add_to_cart);
            load_album(id);
        }

        async void load_album(int id)
        {
            Exception exception = null;

            try
            {
                // Load the news
                album = await Http_get.get_album_by_id(id);

                var comment_vm = await CommentViewModel.load_comments("/albums/" + album.id.ToString());
                commentlist = comment_vm;
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Album error").ShowAsync();
        }

        async void load_albums()
        {
            Exception exception = null;
            albumlist = new ObservableCollection<Album>();

            try
            {
                var albums = (List<Album>)await Http_get.get_object(new List<Album>(), "albums");
                foreach (var item in albums)
                    albumlist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Album Error").ShowAsync();
        }

        async public void send_comment()
        {
            if (await CommentViewModel.send_comment(comment_content, "albums", album.id.ToString()))
            {
                // New comment to add in the observable collection in order to refresh the list ...
                var new_comment = new Comment();
                new_comment.author_id = Singleton.Instance.Current_user.id;
                new_comment.content = comment_content;
                commentlist.Add(new_comment);
                // To delete text in comment bar
                comment_content = "";
            }
        }

        public void add_to_cart()
        {
            //                        USER ID,                            ALBUM ID,   TYPE,  GIFT USER ID (IF < 0 : NOT A GIFT)
            CartViewModel.add_to_cart(Singleton.Instance.Current_user.id, album.id, "Album", 0);
        }
    }
}
