﻿using System;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Activation;
using Windows.ApplicationModel.Core;
using Windows.Graphics.Imaging;
using Windows.Security.Cryptography.Core;
using Windows.Storage;
using Windows.Storage.Pickers;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Ioc;
using SoonZik.Controls;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class ProfilUserViewModel : ViewModelBase
    {
        #region Attribute

        private readonly CoreApplicationView _coreApplicationView;
        private User _currentUser;
        public User CurrentUser
        {
            get { return _currentUser; }
            set
            {
                _currentUser = value;
                RaisePropertyChanged("CurrentUser");
            }
        }

        public INavigationService Navigation;
        private string _newImagePath;

        public User SelectUser
        {
            get { return _selectUser; }
            set
            {
                _selectUser = value;
                RaisePropertyChanged("SelectUser");
            }
        }

        private User _selectUser;

        public ICommand FollowerCommand { get; private set; }
        public ICommand SelectionCommand { get; private set; }
        public ICommand EditClickCommand { get; private set; }
        public ICommand TappedCommand { get; private set; }

        public bool NeedUpdate;

        private bool _canUdpate;

        public bool CanUpdate
        {
            get { return _canUdpate; }
            set
            {
                _canUdpate = value;
                RaisePropertyChanged("CanUpdate");
            }
        }

        private string _buttonContent;

        public string ButtonContent
        {
            get { return _buttonContent; }
            set
            {
                _buttonContent = value;
                RaisePropertyChanged("ButtonContent");
            }
        }

        #endregion

        #region Ctor

        [PreferredConstructor]
        public ProfilUserViewModel()
        {
            Navigation = new NavigationService();
            NeedUpdate = false;
            CanUpdate = false;
            ButtonContent = "Editer mes informations";
            SelectionCommand = new RelayCommand(SelectionExecute);
            EditClickCommand = new RelayCommand(EditInformationExecute);
            FollowerCommand = new RelayCommand(FollowerCommandExecute);
            TappedCommand = new RelayCommand(TappedCommandExecute);
            _coreApplicationView = CoreApplication.GetCurrentView();
            //Navigation.GoBack();
        }

        #endregion

        #region Method

        private void TappedCommandExecute()
        {
            _newImagePath = string.Empty;
            FileOpenPicker filePicker = new FileOpenPicker();
            filePicker.SuggestedStartLocation = PickerLocationId.PicturesLibrary;
            filePicker.ViewMode = PickerViewMode.Thumbnail;

            // Filter to include a sample subset of file types
            filePicker.FileTypeFilter.Clear();
            filePicker.FileTypeFilter.Add(".bmp");
            filePicker.FileTypeFilter.Add(".png");
            filePicker.FileTypeFilter.Add(".jpeg");
            filePicker.FileTypeFilter.Add(".jpg");

            filePicker.PickSingleFileAndContinue();
            _coreApplicationView.Activated += ViewActivated; 
        }

        private async void ViewActivated(CoreApplicationView sender, IActivatedEventArgs args1)
        {
            FileOpenPickerContinuationEventArgs args = args1 as FileOpenPickerContinuationEventArgs;

            if (args != null)
            {
                if (args.Files.Count == 0) return;

                _coreApplicationView.Activated -= ViewActivated;
                StorageFile storageFile = args.Files[0];
                var stream = await storageFile.OpenAsync(FileAccessMode.Read);
                var bitmapImage = new BitmapImage();
                await bitmapImage.SetSourceAsync(stream);

                var decoder = await BitmapDecoder.CreateAsync(stream);
                CurrentUser.profilImage = bitmapImage;
                var name = storageFile.Name;
                var contentType = storageFile.ContentType;
                //GetUserKey(name, contentType, bitmapImage);
                SelectionExecute();
            }
        }

        private void GetUserKey(string name, string contentType, BitmapImage bitmapImage)
        {
            var get = new HttpRequestGet();

            var userKey = get.GetUserKey(Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                var key = task.Result as string;
                if (key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                    var cryptographic = EncriptSha256.EncriptStringToSha256(Singleton.Instance().CurrentUser.salt + stringEncrypt);
                    UploadImage(name, contentType, bitmapImage, cryptographic);
                }
            });
        }

        private void UploadImage(string name, string contentType, BitmapImage bitmapImage, string cryptographic)
        {
            var post = new HttpRequestPost();
            var resPost = post.UploadImage(bitmapImage, cryptographic, CurrentUser.id.ToString(), contentType, name);
            resPost.ContinueWith(delegate(Task<string> tmp)
            {
                var test = tmp.Result;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {

                    });
                }
            });
        }

        private void FollowerCommandExecute()
        {
            ProfilArtisteViewModel.TheUser = SelectUser;
            GlobalMenuControl.SetChildren(new ProfilArtiste());
        }

        private void SelectionExecute()
        {
            if (Singleton.Instance().ItsMe)
                CurrentUser = Singleton.Instance().CurrentUser;
            else if (!Singleton.Instance().ItsMe)
                CurrentUser = Singleton.Instance().SelectedUser;
        }
        
        private void EditInformationExecute()
        {
            var loader = new Windows.ApplicationModel.Resources.ResourceLoader();
            if (!NeedUpdate)
            {
                CanUpdate = true;
                ButtonContent = loader.GetString("PostEdit");
                NeedUpdate = true;
            }
            else if (NeedUpdate)
            {
                CanUpdate = false;
                var task = Task.Run(async () => await UpdateData());
                task.Wait();
                new MessageDialog(loader.GetString("UpdateInformation")).ShowAsync();
                ButtonContent = loader.GetString("Edit");
                NeedUpdate = false;
            }
        }

        private async Task UpdateData()
        {
            var getRequest = new HttpRequestGet();
            var userKey = await getRequest.GetUserKey(CurrentUser.id.ToString()) as string;
            if (userKey != null)
            {
                var hash = HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha256);
                var ch = hash.CreateHash();
            }
        }

        #endregion
    }
}