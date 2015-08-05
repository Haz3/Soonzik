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

namespace SoonZik.ViewModels
{
    class NewsViewModel
    {
        public ObservableCollection<News> newslist { get; set; }



        public NewsViewModel()
        {
            load_news();
        }

        async void load_news()
        {
            Exception exception = null;
            var request = new Http_get();
            newslist = new ObservableCollection<News>();
            List<News> list = new List<News>();

            try
            {
                var news = (List<News>)await request.get_object_list(list, "news");

                foreach (var item in news)
                    newslist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message,"News error");
                //await msgdlg.ShowAsync();
            }
        }
    }
}
