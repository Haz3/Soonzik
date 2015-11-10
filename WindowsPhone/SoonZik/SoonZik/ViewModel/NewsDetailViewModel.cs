﻿using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.System.UserProfile;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class NewsDetailViewModel : ViewModelBase
    {
        #region Ctor

        public NewsDetailViewModel()
        {
            SendComment = new RelayCommand(SendCommentExecute);
            LikeCommand = new RelayCommand(LikeCommandExecute);
            SelectionCommand = new RelayCommand(SelectionCommandExecute);
            ShareTapped = new RelayCommand(ShareTappedExecute);
        }

        #endregion

        private void SelectionCommandExecute()
        {
            SelectNews = NewsViewModel.DetailSelectedNews;
            Like = bm2;
            var ci = new CultureInfo(GlobalizationPreferences.Languages[0]);
            if (ci.Name.Equals("en-US"))
            {
                NewsContent = SelectNews.content;
                NewsTitle = SelectNews.title;
            }
            else if (ci.Name.Equals("fr-FR"))
            {
                NewsContent = SelectNews.content;
                NewsTitle = SelectNews.title;
            }
            LoadComment();
        }

        #region Attribute

        private bool share = false;
        public static Popup SharePopup { get; set; }

        public ICommand ShareTapped { get; set; }
        private string _crypto { get; set; }
        private BitmapImage _like;

        private readonly BitmapImage bm =
            new BitmapImage(new Uri("ms-appx:///Resources/Icones/like_icon.png", UriKind.RelativeOrAbsolute));

        private readonly BitmapImage bm2 =
            new BitmapImage(new Uri("ms-appx:///Resources/Icones/notlike_icon.png", UriKind.RelativeOrAbsolute));

        public BitmapImage Like
        {
            get { return _like; }
            set
            {
                _like = value;
                RaisePropertyChanged("Like");
            }
        }

        public ICommand LikeCommand { get; private set; }
        public ICommand SendComment { get; private set; }
        public ICommand SelectionCommand { get; private set; }
        private ObservableCollection<Comments> _listCommNews;

        public ObservableCollection<Comments> ListCommNews
        {
            get { return _listCommNews; }
            set
            {
                _listCommNews = value;
                RaisePropertyChanged("ListCommNews");
            }
        }

        public News SelectNews { get; set; }
        private string _newsContent;

        public string NewsContent
        {
            get { return _newsContent; }
            set
            {
                _newsContent = value;
                RaisePropertyChanged("NewsContent");
            }
        }

        private string _newsTitle;

        public string NewsTitle
        {
            get { return _newsTitle; }
            set
            {
                _newsTitle = value;
                RaisePropertyChanged("NewsTitle");
            }
        }

        private string _textComment;

        public string TextComment
        {
            get { return _textComment; }
            set
            {
                _textComment = value;
                RaisePropertyChanged("TextComment");
            }
        }

        #endregion

        #region Method

        private void LikeCommandExecute()
        {
            Like = bm;
            //TODO do the like
        }

        private void LoadComment()
        {
            TextComment = "";
            var request = new HttpRequestGet();
            ListCommNews = new ObservableCollection<Comments>();
            var elem = "news/" + SelectNews.id + "/comments";
            var listCom = request.GetListObject(new List<Comments>(), elem);
            listCom.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Comments>;
                if (res != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        foreach (var item in res)
                        {
                            ListCommNews.Add(item);
                        }
                    });
                }
            });
        }

        private void SendCommentExecute()
        {
            var request = new HttpRequestGet();
            var post = new HttpRequestPost();
            try
            {
                var userKey = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
                userKey.ContinueWith(delegate(Task<object> task)
                {
                    var key = task.Result as string;
                    if (key != null)
                    {
                        var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                        _crypto =
                            EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
                                                                stringEncrypt);
                    }
                    var test = post.SendComment(TextComment, null, SelectNews, _crypto,
                        Singleton.Singleton.Instance().CurrentUser);
                    test.ContinueWith(delegate(Task<string> tmp)
                    {
                        var res = tmp.Result;
                        if (res != null)
                        {
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                LoadComment);
                        }
                    });
                });
            }
            catch (Exception)
            {
                new MessageDialog("Erreur lors du post").ShowAsync();
            }
        }

        private void ShareTappedExecute()
        {
            share = true;
            SharePopup = new Popup();
            var content = new NewsSharePopup(SelectNews);
            double width = content.Width;
            double height = content.Height;
            SharePopup.Child = content;
            SharePopup.VerticalOffset = (Window.Current.Bounds.Height - height) / 2;
            SharePopup.HorizontalOffset = (Window.Current.Bounds.Width - width) / 2;
            SharePopup.IsOpen = true;
            SharePopup.Closed += SharePopupOnClosed;
        }

        private void SharePopupOnClosed(object sender, object e)
        {
            SharePopup.IsOpen = false;
        }

        #endregion
    }
}