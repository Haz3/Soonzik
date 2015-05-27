using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest.Poco;
using  GalaSoft.MvvmLight;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class FriendViewModel : ViewModelBase
    {
        #region Attribute
        readonly Windows.Storage.ApplicationDataContainer _localSettings = Windows.Storage.ApplicationData.Current.LocalSettings;
        
        private ObservableCollection<User> _sources; 
        public ObservableCollection<User> Sources
        {
            get { return _sources; }
            set
            {
                _sources = value;
                RaisePropertyChanged("Sources");
            } 
            
        }
        private List<AlphaKeyGroups<User>> _itemSource;
        public List<AlphaKeyGroups<User>> ItemSource
        {
            get { return _itemSource; }
            set
            {
                _itemSource = value;
                RaisePropertyChanged("ItemSource");
            }
        }

        public RelayCommand TappedCommand
        {
            get; private set; 
        }
        
        #endregion

        #region Ctor
        public FriendViewModel()
        {
            Sources = new ObservableCollection<User>();

            if (_localSettings != null && (string) _localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                Sources = Singleton.Instance().CurrentUser.Friends;
                ItemSource = AlphaKeyGroups<User>.CreateGroups(Sources, CultureInfo.CurrentUICulture, s => s.Username, true);
            }
            TappedCommand = new RelayCommand(Execute);
        }

        #endregion

        #region Method
        private void Execute()
        {
            var messagePrompt = new MessagePrompt
            {
                Title = "Que voulez vous faire ?",
                IsAppBarVisible = true,
                VerticalAlignment = VerticalAlignment.Center,
                Body = new ButtonFriendPopUp(),
                Opacity = 0.6
            };
            messagePrompt.Show();
        }

        #endregion
    }
}
