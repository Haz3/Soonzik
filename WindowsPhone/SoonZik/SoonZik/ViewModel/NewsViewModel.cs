﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class NewsViewModel : ViewModelBase
    {
        #region Attribute

        public static MessagePrompt MessagePrompt { get; set; }

        public ObservableCollection<News> ListNews
        {
            get { return _listNews; }
            set
            {
                _listNews = value;
                RaisePropertyChanged("ListNews");
            }
        }

        private ObservableCollection<News> _listNews;

        public RelayCommand ShareTapped { get; set; }


        private News _selectedNews;

        public News SelectedNews
        {
            get
            {
                return _selectedNews;
            }
            set
            {
                _selectedNews = value;
                RaisePropertyChanged("SelectedNews");
            }
        }

        #endregion

        #region Ctor

        public NewsViewModel()
        {
            var task = Task.Run(async () => await Charge());
            task.Wait();
            ShareTapped = new RelayCommand(ShareTappedExecute);
        }

        #endregion

        #region Method

        private void ShareTappedExecute()
        {
            var newsBody = new NewsSharePopup(SelectedNews);
            MessagePrompt = new MessagePrompt
            {
                Title = "Partager",
                IsAppBarVisible = false,
                VerticalAlignment = VerticalAlignment.Center,
                Body = newsBody,
                Opacity = 0.6
            };
            MessagePrompt.ActionPopUpButtons.Clear();
            MessagePrompt.Show();
        }

        public async Task Charge()
        {
            var request = new HttpRequestGet();
            try
            {
                var list = (List<News>) await request.GetListObject(new List<News>(), "news");
                _listNews = new ObservableCollection<News>();
                foreach (var item in list)
                {
                    _listNews.Add(item);
                }
            }
            catch (Exception e)
            {
                
            }
        }
        #endregion
    }
}
