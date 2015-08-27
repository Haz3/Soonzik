using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Tools;
using SoonZik.Models;
using System.Collections.ObjectModel;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class NewsListViewModel
    {
        public ObservableCollection<News> newslist { get; set; }



        public NewsListViewModel()
        {
            load_news();
        }

        async void load_news()
        {
            Exception exception = null;
            var request = new Http_get();
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
                await new MessageDialog(exception.Message, "News error").ShowAsync();
        }

    }
}
