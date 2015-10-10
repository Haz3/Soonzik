using System;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Activation;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.Graphics.Imaging;
using Windows.Storage;
using Windows.Storage.Pickers;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Ioc;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class ProfilUserViewModel : ViewModelBase
    {
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
            TappedCommand = new RelayCommand(TappedCommandExecute);
            _coreApplicationView = CoreApplication.GetCurrentView();
            //Navigation.GoBack();
        }

        #endregion

        #region Attribute

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

        private string _crypto;
        private readonly CoreApplicationView _coreApplicationView;
        public INavigationService Navigation;
        private string _newImagePath;
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

        #region Method

        private void TappedCommandExecute()
        {
            _newImagePath = string.Empty;
            var filePicker = new FileOpenPicker();
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
            var args = args1 as FileOpenPickerContinuationEventArgs;

            if (args != null)
            {
                if (args.Files.Count == 0) return;

                _coreApplicationView.Activated -= ViewActivated;
                var storageFile = args.Files[0];
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

            var userKey = get.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                var key = task.Result as string;
                if (key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                    var cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
                                                            stringEncrypt);
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
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () => { });
                }
            });
        }

        private void SelectionExecute()
        {
            if (Singleton.Singleton.Instance().ItsMe)
                CurrentUser = Singleton.Singleton.Instance().CurrentUser;
            else if (!Singleton.Singleton.Instance().ItsMe)
                CurrentUser = Singleton.Singleton.Instance().SelectedUser;
        }

        private void EditInformationExecute()
        {
            var loader = new ResourceLoader();
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
            var request = new HttpRequestGet();
            var post = new HttpRequestPost();
            try
            {
                var userKey = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
                await userKey.ContinueWith(delegate(Task<object> task)
                {
                    var key = task.Result as string;
                    if (key != null)
                    {
                        var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
                        _crypto =
                            EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
                                                                stringEncrypt);
                    }
                    var test = post.Update(CurrentUser, _crypto);
                    test.ContinueWith(delegate(Task<string> tmp) { var res = tmp.Result; });
                });
            }
            catch (Exception)
            {
                new MessageDialog("Erreur lors de l'update").ShowAsync();
            }
        }

        #endregion
    }
}