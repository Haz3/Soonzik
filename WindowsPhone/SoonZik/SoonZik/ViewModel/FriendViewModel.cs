using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using Windows.Storage;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class FriendViewModel : ViewModelBase
    {
        #region Attribute
        readonly ApplicationDataContainer _localSettings = ApplicationData.Current.LocalSettings;

        public static MessagePrompt MeaagePrompt { get; set; }

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

        private User _selectedUser;

        public User SelectedUser
        {
            get
            {
                return _selectedUser;
            }
            set
            {
                _selectedUser = value;
                RaisePropertyChanged("SelectedUser");
            }
        }

        #endregion

        #region Ctor
        public FriendViewModel()
        {
            Sources = new ObservableCollection<User>();

            if (_localSettings != null && (string) _localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                Sources = Singleton.Instance().CurrentUser.friends;
                ItemSource = AlphaKeyGroups<User>.CreateGroups(Sources, CultureInfo.CurrentUICulture, s => s.username, true);
            }
            TappedCommand = new RelayCommand(Execute);
        }

        #endregion

        #region Method
        private void Execute()
        {
            MeaagePrompt = new MessagePrompt
            {
                IsAppBarVisible = true,
                VerticalAlignment = VerticalAlignment.Center,
                Body = new ButtonFriendPopUp(SelectedUser.id),
                Opacity = 0.6
            };
            MeaagePrompt.Show();
        }

        #endregion
    }
}
