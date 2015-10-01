using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using Windows.ApplicationModel.Background;
using Windows.Foundation.Collections;
using Windows.Media;
using Windows.Media.Playback;
using Windows.Storage;
using Windows.UI.Xaml;
using SoonZik.Helpers;
using SoonZik.HttpRequest.Poco;
using SoonZik.MyPlaylistManager;
using SoonZik.Utils;

namespace SoonZik.BackgroundAudioTask
{
    enum ForegroundAppStatus
    {
        Active,
        Suspended,
        Unknown
    }

    public sealed class MyBackgroundAudioTask : IBackgroundTask
    {
        #region Private fields, properties
        private const string UrlMusique = "http://soonzikapi.herokuapp.com/musics/get/";
        private SystemMediaTransportControls systemmediatransportcontrol;
        private MyPlaylistManager.MyPlaylistManager playlistManager;
        private BackgroundTaskDeferral deferral; // Used to keep task alive
        private ForegroundAppStatus foregroundAppState = ForegroundAppStatus.Unknown;
        private AutoResetEvent BackgroundTaskStarted = new AutoResetEvent(false);
        private bool backgroundtaskrunning = false;


        public MyPlaylist Playlist
        {
            get
            {
                if (null == playlistManager)
                {
                    playlistManager = new MyPlaylistManager.MyPlaylistManager();
                }
                return playlistManager.Current;
            }
        }
        #endregion
        
        #region IBackgroundTask and IBackgroundTaskInstance Interface Members and handlers
        public void Run(IBackgroundTaskInstance taskInstance)
        {
            Debug.WriteLine("Background Audio Task " + taskInstance.Task.Name + " starting...");
            systemmediatransportcontrol = SystemMediaTransportControls.GetForCurrentView();
            systemmediatransportcontrol.ButtonPressed += systemmediatransportcontrol_ButtonPressed;
            systemmediatransportcontrol.PropertyChanged += systemmediatransportcontrol_PropertyChanged;
            systemmediatransportcontrol.IsEnabled = true;
            systemmediatransportcontrol.IsPauseEnabled = true;
            systemmediatransportcontrol.IsPlayEnabled = true;
            systemmediatransportcontrol.IsNextEnabled = true;
            systemmediatransportcontrol.IsPreviousEnabled = true;

            taskInstance.Canceled += new BackgroundTaskCanceledEventHandler(OnCanceled);
            taskInstance.Task.Completed += Taskcompleted;

            var value = ApplicationSettingsHelper.ReadResetSettingsValue(Constants.AppState);
            if (value == null)
                foregroundAppState = ForegroundAppStatus.Unknown;
            else
                foregroundAppState = (ForegroundAppStatus)Enum.Parse(typeof(ForegroundAppStatus), value.ToString());

            BackgroundMediaPlayer.Current.CurrentStateChanged += Current_CurrentStateChanged;

            Playlist.TrackChanged += playList_TrackChanged;

            BackgroundMediaPlayer.MessageReceivedFromForeground += BackgroundMediaPlayer_MessageReceivedFromForeground;

            if (foregroundAppState != ForegroundAppStatus.Suspended)
            {
                ValueSet message = new ValueSet();
                message.Add(Constants.BackgroundTaskStarted, "");
                BackgroundMediaPlayer.SendMessageToForeground(message);
            }
            BackgroundTaskStarted.Set();
            backgroundtaskrunning = true;

            ApplicationSettingsHelper.SaveSettingsValue(Constants.BackgroundTaskState, Constants.BackgroundTaskRunning);
            deferral = taskInstance.GetDeferral(); 
        }

        void Taskcompleted(BackgroundTaskRegistration sender, BackgroundTaskCompletedEventArgs args)
        {
            Debug.WriteLine("MyBackgroundAudioTask " + sender.TaskId + " Completed...");
            deferral.Complete();
        }

        private void OnCanceled(IBackgroundTaskInstance sender, BackgroundTaskCancellationReason reason)
        {
            Debug.WriteLine("MyBackgroundAudioTask " + sender.Task.TaskId + " Cancel Requested...");
            try
            {
                ApplicationSettingsHelper.SaveSettingsValue(Constants.CurrentTrack, Playlist.CurrentTrackName);
                ApplicationSettingsHelper.SaveSettingsValue(Constants.Position, BackgroundMediaPlayer.Current.Position.ToString());
                ApplicationSettingsHelper.SaveSettingsValue(Constants.BackgroundTaskState, Constants.BackgroundTaskCancelled);
                ApplicationSettingsHelper.SaveSettingsValue(Constants.AppState, Enum.GetName(typeof(ForegroundAppStatus), foregroundAppState));
                backgroundtaskrunning = false;
                systemmediatransportcontrol.ButtonPressed -= systemmediatransportcontrol_ButtonPressed;
                systemmediatransportcontrol.PropertyChanged -= systemmediatransportcontrol_PropertyChanged;
                Playlist.TrackChanged -= playList_TrackChanged;

                playlistManager.ClearPlaylist();
                playlistManager = null;
                BackgroundMediaPlayer.Shutdown();
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.ToString());
            }
            deferral.Complete(); 
            Debug.WriteLine("MyBackgroundAudioTask Cancel complete...");
        }
        #endregion

        #region SysteMediaTransportControls related functions and handlers
        private void UpdateUVCOnNewTrack()
        {
            systemmediatransportcontrol.PlaybackStatus = MediaPlaybackStatus.Playing;
            systemmediatransportcontrol.DisplayUpdater.Type = MediaPlaybackType.Music;
            systemmediatransportcontrol.DisplayUpdater.MusicProperties.Title = Playlist.CurrentTrackName;
            systemmediatransportcontrol.DisplayUpdater.Update();
        }

        void systemmediatransportcontrol_PropertyChanged(SystemMediaTransportControls sender, SystemMediaTransportControlsPropertyChangedEventArgs args)
        {
            //TODO: If soundlevel turns to muted, app can choose to pause the music
        }

        private void systemmediatransportcontrol_ButtonPressed(SystemMediaTransportControls sender, SystemMediaTransportControlsButtonPressedEventArgs args)
        {
            switch (args.Button)
            {
                case SystemMediaTransportControlsButton.Play:
                    Debug.WriteLine("UVC play button pressed");
                    if (!backgroundtaskrunning)
                    {
                        bool result = BackgroundTaskStarted.WaitOne(2000);
                        if (!result)
                            throw new Exception("Background Task didnt initialize in time");
                    }
                    StartPlayback();
                    break;
                case SystemMediaTransportControlsButton.Pause:
                    Debug.WriteLine("UVC pause button pressed");
                    try
                    {
                        BackgroundMediaPlayer.Current.Pause();
                    }
                    catch (Exception ex)
                    {
                        Debug.WriteLine(ex.ToString());
                    }
                    break;
                case SystemMediaTransportControlsButton.Next:
                    Debug.WriteLine("UVC next button pressed");
                    SkipToNext();
                    break;
                case SystemMediaTransportControlsButton.Previous:
                    Debug.WriteLine("UVC previous button pressed");
                    SkipToPrevious();
                    break;
            }
        }
        #endregion

        #region Playlist management functions and handlers
        private void StartPlayback()
        {
            LocalFolderHelper.ReadTimestamp().ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as Music;
                if (res != null)
                {
                    MyPlaylist.AddTracks(new Uri(UrlMusique + res.id, UriKind.RelativeOrAbsolute)); 
                    try
                    {
                        if (Playlist.CurrentTrackName == string.Empty)
                        {
                            var currenttrackname = ApplicationSettingsHelper.ReadResetSettingsValue(Constants.CurrentTrack);
                            var currenttrackposition = ApplicationSettingsHelper.ReadResetSettingsValue(Constants.Position);
                            if (currenttrackname != null)
                                if (currenttrackposition == null)
                                    Playlist.StartTrackAt((string)currenttrackname);
                                else
                                    Playlist.StartTrackAt((string)currenttrackname,
                                        TimeSpan.Parse((string)currenttrackposition));
                            else
                                Playlist.PlayAllTracks();
                        }
                        else
                            BackgroundMediaPlayer.Current.Play();
                    }
                    catch (Exception ex)
                    {
                        Debug.WriteLine(ex.ToString());
                    }
                }
            });
        }

        void playList_TrackChanged(MyPlaylist sender, object args)
        {
            UpdateUVCOnNewTrack();
            ApplicationSettingsHelper.SaveSettingsValue(Constants.CurrentTrack, sender.CurrentTrackName);

            if (foregroundAppState == ForegroundAppStatus.Active)
            {
                ValueSet message = new ValueSet();
                message.Add(Constants.Trackchanged, sender.CurrentTrackName);
                BackgroundMediaPlayer.SendMessageToForeground(message);
            }
        }

        private void SkipToPrevious()
        {
            systemmediatransportcontrol.PlaybackStatus = MediaPlaybackStatus.Changing;
            Playlist.SkipToPrevious();
        }

        private void SkipToNext()
        {
            systemmediatransportcontrol.PlaybackStatus = MediaPlaybackStatus.Changing;
            Playlist.SkipToNext();
        }

        #endregion

        #region Background Media Player Handlers
        void Current_CurrentStateChanged(MediaPlayer sender, object args)
        {
            if (sender.CurrentState == MediaPlayerState.Playing)
            {
                systemmediatransportcontrol.PlaybackStatus = MediaPlaybackStatus.Playing;
            }
            else if (sender.CurrentState == MediaPlayerState.Paused)
            {
                systemmediatransportcontrol.PlaybackStatus = MediaPlaybackStatus.Paused;
            }
        }

        void BackgroundMediaPlayer_MessageReceivedFromForeground(object sender, MediaPlayerDataReceivedEventArgs e)
        {
            foreach (string key in e.Data.Keys)
            {
                switch (key.ToLower())
                {
                    case Constants.AppSuspended:
                        Debug.WriteLine("App suspending");
                        foregroundAppState = ForegroundAppStatus.Suspended;
                        ApplicationSettingsHelper.SaveSettingsValue(Constants.CurrentTrack, Playlist.CurrentTrackName);
                        break;
                    case Constants.AppResumed:
                        Debug.WriteLine("App resuming");
                        foregroundAppState = ForegroundAppStatus.Active;
                        break;
                    case Constants.StartPlayback:
                        Debug.WriteLine("Starting Playback");
                        StartPlayback();
                        break;
                    case Constants.SkipNext:
                        Debug.WriteLine("Skipping to next");
                        SkipToNext();
                        break;
                    case Constants.SkipPrevious:
                        Debug.WriteLine("Skipping to previous");
                        SkipToPrevious();
                        break;
                }
            }
        }
        #endregion

    }
}
