using System;
using System.Collections.ObjectModel;
using System.Diagnostics;
using Windows.Foundation;
using Windows.Media.Playback;

namespace SoonZik.MyPlaylistManager
{
    public sealed class MyPlaylistManager
    {
        #region Private members

        private static MyPlaylist instance;

        #endregion

        #region Playlist management methods/properties

        public MyPlaylist Current
        {
            get
            {
                if (instance == null)
                {
                    instance = new MyPlaylist();
                }
                return instance;
            }
        }

        public void ClearPlaylist()
        {
            instance = null;
        }

        #endregion
    }

    public sealed class MyPlaylist
    {
        #region Private members

        private static ObservableCollection<string> tracks;
        private const string UrlMusique = "http://soonzikapi.herokuapp.com/musics/get/";
        //private static String[] tracks;
        private int CurrentTrackId = -1;
        private readonly MediaPlayer mediaPlayer;
        private TimeSpan startPosition = TimeSpan.FromSeconds(0);

        internal MyPlaylist()
        {
            mediaPlayer = BackgroundMediaPlayer.Current;
            mediaPlayer.MediaOpened += MediaPlayer_MediaOpened;
            mediaPlayer.MediaEnded += MediaPlayer_MediaEnded;
            mediaPlayer.CurrentStateChanged += mediaPlayer_CurrentStateChanged;
            mediaPlayer.MediaFailed += mediaPlayer_MediaFailed;
            //LocalFolderHelper.ReadTimestamp().ContinueWith(delegate(Task<object> tmp)
            //{
            //    var res = tmp.Result as List<Music>;
            //    if (res != null)
            //    {
            //        foreach (var music in res)
            //        {
            //            MyPlaylist.AddTracks(new Uri(UrlMusique + music.id, UriKind.RelativeOrAbsolute));
            //        }
            //    }
            //});
        }

        #endregion

        #region Public properties, events and handlers

        public string CurrentTrackName
        {
            get
            {
                if (CurrentTrackId == -1)
                {
                    return String.Empty;
                }
                if (CurrentTrackId < tracks.Count)
                {
                    var fullUrl = tracks[CurrentTrackId];
                    return fullUrl;
                    //return fullUrl.Split('/')[fullUrl.Split('/').Length - 1];
                }
                throw new ArgumentOutOfRangeException("Track Id is higher than total number of tracks");
            }
        }

        public event TypedEventHandler<MyPlaylist, object> TrackChanged;

        #endregion

        #region MediaPlayer Handlers

        private void mediaPlayer_CurrentStateChanged(MediaPlayer sender, object args)
        {
            if (sender.CurrentState == MediaPlayerState.Playing && startPosition != TimeSpan.FromSeconds(0))
            {
                // if the start position is other than 0, then set it now
                sender.Position = startPosition;
                sender.Volume = 1.0;
                startPosition = TimeSpan.FromSeconds(0);
                sender.PlaybackMediaMarkers.Clear();
            }
        }

        private void MediaPlayer_MediaOpened(MediaPlayer sender, object args)
        {
            // wait for media to be ready
            sender.Play();
            Debug.WriteLine("New Track" + CurrentTrackName);
            TrackChanged.Invoke(this, CurrentTrackName);
        }

        private void MediaPlayer_MediaEnded(MediaPlayer sender, object args)
        {
            SkipToNext();
        }

        private void mediaPlayer_MediaFailed(MediaPlayer sender, MediaPlayerFailedEventArgs args)
        {
            Debug.WriteLine("Failed with error code " + args.ExtendedErrorCode);
        }

        #endregion

        #region Playlist command handlers

        private void StartTrackAt(int id)
        {
            var source = tracks[id];
            CurrentTrackId = id;
            mediaPlayer.AutoPlay = false;
            mediaPlayer.SetUriSource(new Uri(source));
        }

        public void StartTrackAt(string TrackName)
        {
            for (var i = 0; i < tracks.Count; i++)
            {
                if (tracks[i].Contains(TrackName))
                {
                    var source = tracks[i];
                    CurrentTrackId = i;
                    mediaPlayer.AutoPlay = false;
                    mediaPlayer.SetUriSource(new Uri(source));
                }
            }
        }

        public void StartTrackAt(string TrackName, TimeSpan position)
        {
            for (var i = 0; i < tracks.Count; i++)
            {
                if (tracks[i].Contains(TrackName))
                {
                    CurrentTrackId = i;
                    break;
                }
            }

            mediaPlayer.AutoPlay = false;
            mediaPlayer.Volume = 0;
            startPosition = position;
            mediaPlayer.SetUriSource(new Uri(tracks[CurrentTrackId]));
        }

        public void PlayAllTracks()
        {
            StartTrackAt(0);
        }

        public void SkipToNext()
        {
            StartTrackAt((CurrentTrackId + 1)%tracks.Count);
        }

        public void SkipToPrevious()
        {
            if (CurrentTrackId == 0)
            {
                StartTrackAt(CurrentTrackId);
            }
            else
            {
                StartTrackAt(CurrentTrackId - 1);
            }
        }

        public static void AddTracks(Uri trackUri)
        {
            if (tracks == null)
                tracks = new ObservableCollection<string>();
            tracks.Add(trackUri.ToString());
        }

        public void CleanTracks()
        {
            tracks.Clear();
        }

        #endregion
    }
}