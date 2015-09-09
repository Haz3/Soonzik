using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;

namespace SoonZik.ViewModels
{
    class NewsViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<News> newslist { get; set; }

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

        private News _news;
        public News news
        {
            get { return _news; }
            set
            {
                _news = value;
                OnPropertyChanged("news");
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

        private string _content;
        public string content
        {
            get { return _content; }
            set
            {
                _content = value;
                OnPropertyChanged("content");
            }
        }

        public ICommand do_send_comment
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

        // CLICK SUR UNE NEWS CTOR
        public NewsViewModel(int id)
        {
            commentlist = new ObservableCollection<Comment>();
            do_send_comment = new RelayCommand(send_comment);
            load_news(id);
        }

        // CTOR POUR LA PAGE LISTE NEWS
        public NewsViewModel()
        {
            load_news_list();
        }

        async public void send_comment()
        {
            if (await CommentViewModel.send_comment(comment_content, "news", news.id.ToString()))
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

        async public void load_news(int id)
        {
            Exception exception = null;

            try
            {
                // Load the news
                news = await Http_get.get_news_by_id(id);

                //news = await Http_get.get_news_by_id_and_language(id, "FR");

                //news = await Http_get.get_news_by_id_and_language(id, "EN");
                // Check language
                if (news.newstexts.Any())
                {
                    if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                        content = news.newstexts[0].content;
                    else
                    {
                        if ((news.newstexts).Count == 2)
                            content = news.newstexts[1].content;
                        else
                            content = "No content available.";
                    }
                }
                else
                {
                    if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                        content = "Pas de contenu disponible.";
                    else
                        content = "No content available.";
                }

                var comment_vm = await CommentViewModel.load_comments("/news/" + news.id.ToString());
                commentlist = comment_vm;
                //commentlist.Reverse(); // DONT WORK .....
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "News error").ShowAsync();
        }

        async void load_news_list()
        {
            Exception exception = null;
            newslist = new ObservableCollection<News>();

            try
            {
                List<News> news;

                if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                 news = (List<News>)await Http_get.get_object(new List<News>(), "news?language=FR");
                else
                 news = (List<News>)await Http_get.get_object(new List<News>(), "news?language=EN");

                foreach (var item in news)
                    newslist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "News list error").ShowAsync();
        }
    }
}
