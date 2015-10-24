using System;
using System.Diagnostics;
using System.Threading;
using Windows.ApplicationModel;
using Windows.Foundation;
using Windows.Foundation.Collections;
using Windows.Media.Playback;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Media.Imaging;
using Windows.UI.Xaml.Navigation;
using SoonZik.Helpers;
using SoonZik.Utils;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class BackgroundAudioPlayer : Page
    {
        #region Private field

        private int _actuelMusic = 0;
        private bool _isPlaylist;
        private readonly AutoResetEvent SererInitialized;
        private bool isMyBackgroundTaskRunning;

        private bool IsMyBackgroundTaskRunning
        {
            get
            {
                if (isMyBackgroundTaskRunning)
                    return true;

                var value = ApplicationSettingsHelper.ReadResetSettingsValue(Constants.BackgroundTaskState);
                if (value == null)
                {
                    return false;
                }
                isMyBackgroundTaskRunning = ((String)value).Equals(Constants.BackgroundTaskRunning);
                return isMyBackgroundTaskRunning;
            }
        }

        private string CurrentTrack
        {
            get
            {
                var value = ApplicationSettingsHelper.ReadResetSettingsValue(Constants.CurrentTrack);
                if (value != null)
                {
                    return (String)value;
                }
                return String.Empty;
            }
        }

        #endregion

        #region Ctor

        public BackgroundAudioPlayer()
        {
            InitializeComponent();
            SererInitialized = new AutoResetEvent(false);
            NavigationCacheMode = NavigationCacheMode.Required;
            Loaded += OnLoaded;
        }

        private void OnLoaded(object sender, RoutedEventArgs routedEventArgs)
        {
            SetMusicAndInfo();
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            Application.Current.Suspending += ForegroundApp_Suspending;
            Application.Current.Resuming += ForegroundApp_Resuming;
            ApplicationSettingsHelper.SaveSettingsValue(Constants.AppState, Constants.ForegroundAppActive);
        }

        #endregion

        #region Foreground App Lifecycle handler

        private void ForegroundApp_Resuming(object sender, object e)
        {
            ApplicationSettingsHelper.SaveSettingsValue(Constants.AppState, Constants.ForegroundAppActive);

            // Verify if the task was running before
            if (IsMyBackgroundTaskRunning)
            {
                //if yes, reconnect to media play handlers
                AddMediaPlayerEventHandlers();

                //send message to background task that app is resumed, so it can start sending notifications
                var messageDictionary = new ValueSet();
                messageDictionary.Add(Constants.AppResumed, DateTime.Now.ToString());
                BackgroundMediaPlayer.SendMessageToBackground(messageDictionary);

                if (BackgroundMediaPlayer.Current.CurrentState == MediaPlayerState.Playing)
                {
                    //playButton.Content = "| |";
                    PlayImage.Source = new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/pause.png", UriKind.RelativeOrAbsolute));
                    // Change to pause button
                }
                else
                {
                    //playButton.Content = ">"; // Change to play button
                    PlayImage.Source = new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/play.png", UriKind.RelativeOrAbsolute));
                }
                txtCurrentTrack.Text = CurrentTrack;
            }
            else
            {
                PlayImage.Source = new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/play.png", UriKind.RelativeOrAbsolute));
                //playButton.Content = ">"; // Change to play button
                txtCurrentTrack.Text = "";
            }
        }

        private void ForegroundApp_Suspending(object sender, SuspendingEventArgs e)
        {
            var deferral = e.SuspendingOperation.GetDeferral();
            var messageDictionary = new ValueSet();
            messageDictionary.Add(Constants.AppSuspended, DateTime.Now.ToString());
            BackgroundMediaPlayer.SendMessageToBackground(messageDictionary);
            RemoveMediaPlayerEventHandlers();
            ApplicationSettingsHelper.SaveSettingsValue(Constants.AppState, Constants.ForegroundAppSuspended);
            deferral.Complete();
        }

        #endregion

        #region Background MediaPlayer Event handlers

        private async void MediaPlayer_CurrentStateChanged(MediaPlayer sender, object args)
        {
            switch (sender.CurrentState)
            {
                case MediaPlayerState.Playing:
                    await Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        //playButton.Content = "| |"; // Change to pause button
                        PlayImage.Source = new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/pause.png", UriKind.RelativeOrAbsolute));
                        //prevButton.IsEnabled = true;
                        //nextButton.IsEnabled = true;
                    }
                        );

                    break;
                case MediaPlayerState.Paused:
                    await
                        Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () =>
                            {
                                //playButton.Content = ">"; // Change to play button
                                PlayImage.Source = new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/play.png", UriKind.RelativeOrAbsolute));
                            }
                            );

                    break;
            }
        }

        private async void BackgroundMediaPlayer_MessageReceivedFromBackground(object sender,
            MediaPlayerDataReceivedEventArgs e)
        {
            foreach (var key in e.Data.Keys)
            {
                switch (key)
                {
                    case Constants.Trackchanged:
                        //When foreground app is active change track based on background message
                        await
                            Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () => { txtCurrentTrack.Text = (string)e.Data[key]; }
                                );
                        break;
                    case Constants.BackgroundTaskStarted:
                        //Wait for Background Task to be initialized before starting playback
                        Debug.WriteLine("Background Task started");
                        SererInitialized.Set();
                        break;
                }
            }
        }

        #endregion

        #region ButtonClick Event Handler

        private void ShullfeImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            throw new NotImplementedException();
        }

        private void RewindImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            var value = new ValueSet();
            value.Add(Constants.SkipPrevious, "");
            BackgroundMediaPlayer.SendMessageToBackground(value);

            // Prevent the user from repeatedly pressing the button and causing 
            // a backlong of button presses to be handled. This button is re-eneabled 
            // in the TrackReady Playstate handler.
            //prevButton.IsEnabled = false;
        }

        private void PlayImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            Debug.WriteLine("Play button pressed from App");
            if (IsMyBackgroundTaskRunning)
            {
                if (MediaPlayerState.Playing == BackgroundMediaPlayer.Current.CurrentState)
                {
                    BackgroundMediaPlayer.Current.Pause();
                    PlayImage.Source = new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/play.png", UriKind.RelativeOrAbsolute));
                }
                else if (MediaPlayerState.Paused == BackgroundMediaPlayer.Current.CurrentState)
                {
                    BackgroundMediaPlayer.Current.Play();
                    PlayImage.Source = new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/pause.png", UriKind.RelativeOrAbsolute));
                }
                else if (MediaPlayerState.Closed == BackgroundMediaPlayer.Current.CurrentState)
                {
                    StartBackgroundAudioTask();
                }
            }
            else
            {
                StartBackgroundAudioTask();
            }
        }

        private void ForwardImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            var value = new ValueSet();
            value.Add(Constants.SkipNext, "");
            BackgroundMediaPlayer.SendMessageToBackground(value);

            // Prevent the user from repeatedly pressing the button and causing 
            // a backlong of button presses to be handled. This button is re-eneabled 
            // in the TrackReady Playstate handler.
            //nextButton.IsEnabled = false;
        }

        private void RepeatImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            throw new NotImplementedException();
        }

        private void prevButton_Click(object sender, RoutedEventArgs e)
        {
        }

        private void playButton_Click(object sender, RoutedEventArgs e)
        {
            Debug.WriteLine("Play button pressed from App");
            if (IsMyBackgroundTaskRunning)
            {
                if (MediaPlayerState.Playing == BackgroundMediaPlayer.Current.CurrentState)
                {
                    BackgroundMediaPlayer.Current.Pause();
                }
                else if (MediaPlayerState.Paused == BackgroundMediaPlayer.Current.CurrentState)
                {
                    BackgroundMediaPlayer.Current.Play();
                }
                else if (MediaPlayerState.Closed == BackgroundMediaPlayer.Current.CurrentState)
                {
                    StartBackgroundAudioTask();
                }
            }
            else
            {
                StartBackgroundAudioTask();
            }
        }

        private void nextButton_Click(object sender, RoutedEventArgs e)
        {
        }

        #endregion

        #region Media Playback Helper methods

        private void RemoveMediaPlayerEventHandlers()
        {
            BackgroundMediaPlayer.Current.CurrentStateChanged -= MediaPlayer_CurrentStateChanged;
            BackgroundMediaPlayer.MessageReceivedFromBackground -= BackgroundMediaPlayer_MessageReceivedFromBackground;
        }

        private void AddMediaPlayerEventHandlers()
        {
            BackgroundMediaPlayer.Current.MediaEnded += CurrentOnMediaEnded;
            BackgroundMediaPlayer.Current.CurrentStateChanged += MediaPlayer_CurrentStateChanged;
            BackgroundMediaPlayer.MessageReceivedFromBackground += BackgroundMediaPlayer_MessageReceivedFromBackground;
        }

        private void CurrentOnMediaEnded(MediaPlayer sender, object args)
        {
            if (_isPlaylist)
            {
                _actuelMusic += 1;
                BackgroundMediaPlayer.Current.SetUriSource(new Uri(Singleton.Singleton.Instance().SelectedMusicSingleton[_actuelMusic].file, UriKind.RelativeOrAbsolute));
                txtCurrentTrack.Text = Singleton.Singleton.Instance().SelectedMusicSingleton[_actuelMusic].title;
                txtCurrentArtist.Text = Singleton.Singleton.Instance().SelectedMusicSingleton[_actuelMusic].user.username;
                ImageMusique.Source = new BitmapImage(new Uri(Constant.UrlImageAlbum + Singleton.Singleton.Instance().SelectedMusicSingleton[_actuelMusic].album.image, UriKind.RelativeOrAbsolute));
            }
            else
            {
                PlayImage.Source = new BitmapImage(new Uri("ms-appx:///Resources/PlayerIcons/play.png", UriKind.RelativeOrAbsolute));
                BackgroundMediaPlayer.Shutdown();
            }
        }

        private void SetMusicAndInfo()
        {
            if (Singleton.Singleton.Instance().SelectedMusicSingleton.Count == 1)
            {
                _isPlaylist = false;
            }
            else if (Singleton.Singleton.Instance().SelectedMusicSingleton.Count > 1)
            {
                _isPlaylist = true;
            }
            BackgroundMediaPlayer.Current.SetUriSource(new Uri(Singleton.Singleton.Instance().SelectedMusicSingleton[_actuelMusic].file, UriKind.RelativeOrAbsolute));
            txtCurrentTrack.Text = Singleton.Singleton.Instance().SelectedMusicSingleton[_actuelMusic].title;
            txtCurrentArtist.Text = Singleton.Singleton.Instance().SelectedMusicSingleton[_actuelMusic].user.username;
            ImageMusique.Source = new BitmapImage(new Uri(Constant.UrlImageAlbum + Singleton.Singleton.Instance().SelectedMusicSingleton[_actuelMusic].album.image, UriKind.RelativeOrAbsolute));
        }

        private void StartBackgroundAudioTask()
        {
            AddMediaPlayerEventHandlers();
            var backgroundtaskinitializationresult = Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
            {
                var result = SererInitialized.WaitOne(2000);
                //Send message to initiate playback
                if (result)
                {
                    var message = new ValueSet();
                    message.Add(Constants.StartPlayback, "0");
                    BackgroundMediaPlayer.SendMessageToBackground(message);
                }
                else
                {
                    throw new Exception("Background Audio Task didn't start in expected time");
                }
            });
            backgroundtaskinitializationresult.Completed = BackgroundTaskInitializationCompleted;
        }

        private void BackgroundTaskInitializationCompleted(IAsyncAction action, AsyncStatus status)
        {
            if (status == AsyncStatus.Completed)
            {
                Debug.WriteLine("Background Audio Task initialized");
            }
            else if (status == AsyncStatus.Error)
            {
                Debug.WriteLine("Background Audio Task could not initialized due to an error ::" + action.ErrorCode);
            }
        }

        #endregion
    }
}