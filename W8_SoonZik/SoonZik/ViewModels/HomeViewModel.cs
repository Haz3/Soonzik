﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.ViewModels;
using SoonZik.Tools;
using System.Collections.ObjectModel;
using SoonZik.Models;
using Windows.UI.Popups;
using SoonZik.ViewModels.Command;
using System.Windows.Input;

namespace SoonZik.ViewModels
{
    class HomeViewModel
    {
        public ObservableCollection<News> news_list { get; set; }
        public ObservableCollection<Album> album_list { get; set; }
        public ObservableCollection<Tweet> tweet_list { get; set; }

        public HomeViewModel()
        {
            load_home();
        }

        async void load_home()
        {
            Exception exception = null;
            news_list = new ObservableCollection<News>();
            album_list = new ObservableCollection<Album>();
            tweet_list = new ObservableCollection<Tweet>();
            string language = null;

            try
            {
                if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                    language = "FR";
                else
                    language = "EN";

                var news = (List<News>)await Http_get.get_object(new List<News>(), "news?language=" + language);
                var albums = (List<Album>)await Http_get.get_object(new List<Album>(), "albums");

               // tweet_list = await TweetViewModel.load_flux_tweets();

                foreach (var item in news)
                    news_list.Add(item);
                foreach (var item in albums)
                    album_list.Add(item);
             
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Home error").ShowAsync();
        }
    }
}
