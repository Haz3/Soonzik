using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.ObjectModel;
using System.ComponentModel;
using SoonZik.Models;
using SoonZik.Tools;
using System.Diagnostics;
using Windows.UI.Popups;
using Windows.UI.Xaml;

namespace SoonZik.ViewModels
{
    class NewsViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<News> newslist { get; set; }

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

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public NewsViewModel(int id)
        {
            load_news(id);
        }

        public NewsViewModel()
        {
            load_news_list();
        }

        async public void load_news(int id)
        {
            Exception exception = null;

            try
            {
                news = await Http_get.get_news_by_id(id);

                // Detect current language and set visibility
                //if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                //    content_en_visibility = Visibility.Collapsed;
                //else
                //    content_fr_visibility = Visibility.Collapsed;

                // if newstexts is not empty -> check current language -> set content

                //    if (news.newstexts[0].content == null)
                //        news.newstexts[0].content = "PAS DE CONTENU DISPONIBLE";
                //    if (news.newstexts.Count == 1)
                //        if (news.newstexts[1].content == null)
                //            news.newstexts[1].content = "NO CONTENT AVAILABLE";



                //if (news.newstexts.Any())
                //{
                //    if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                //        news.content = news.newstexts[0].content;
                //    else
                //        if (news.newstexts.Count == 2)
                //            news.content = news.newstexts[1].content;
                //}
                //else
                //{
                //    if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                //        news.content = "Pas de contenu disponible.";
                //    else
                //        news.content = "No content available.";
                //}

                if (news.newstexts.Any())
                {
                    if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                        content = news.newstexts[0].content;
                    else
                        if (news.newstexts.Count == 1)
                            content = news.newstexts[1].content;
                }
                else
                {
                    if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                        content = "Pas de contenu disponible.";
                    else
                        content = "No content available.";
                }

                // Load comment

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
                var news = (List<News>)await Http_get.get_object(new List<News>(), "news");

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
