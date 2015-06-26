using System;
using System.Collections.Generic;
using System.ComponentModel;
using Windows.Phone.UI.Input;
using Windows.UI.Core;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Navigation;
using SoonZik.HttpRequest.Poco;
using SoonZik.Properties;
using SoonZik.Utils;

namespace SoonZik.Controls
{
    public sealed partial class PlayerControl : Page, INotifyPropertyChanged
    {
        #region Attribute

        private INavigationService _navigationService;
        private DispatcherTimer MyDispatcherTimer { get; set; }
        private TimeSpan MyTimeSpan { get; set; }

        private List<Music> _listOfMusics;
        public List<Music> ListOfMusics
        {
            get { return _listOfMusics; }
            set
            {
                _listOfMusics = value;
                RaisePropertyChanged("ListOfMusics");
            }
        }

        private Music _playedMusic;
        public Music PlayedMusic
        {
            get { return _playedMusic; }
            set
            {
                _playedMusic = value;
                RaisePropertyChanged("PlayedMusic");
            }
        }

        public int CurrentMusicIndex;
        #endregion

        #region ctor and Initializer

        public PlayerControl()
        {
            InitializeComponent();
            DataContext = this;
            Initialize();
        }

        private void Initialize()
        {
            HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;
            MyMediaElement.MediaEnded += MyMediaElement_MediaEnded;
            
            _navigationService = new NavigationService();
            ListOfMusics = new List<Music>();
            Singleton.Instance().SelectedMusicSingleton.file = "http://soonzikapi.herokuapp.com/musics/get/" +
                                                               Singleton.Instance().SelectedMusicSingleton.id;
            ListOfMusics.Add(Singleton.Instance().SelectedMusicSingleton);
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            PlayedMusic = ListOfMusics[0];
            CurrentMusicIndex = 0;
            MyMediaElement.Source = new Uri(Singleton.Instance().SelectedMusicSingleton.file, UriKind.Absolute);
            StartTimer();
            //BackgroundMediaPlayer.Current.SetUriSource(new Uri("ms-appx:///Resources/MusicTest.mp3", UriKind.Absolute));
        }

        #endregion

        #region PlayerButton
        private void RewindImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            if (CurrentMusicIndex == 0)
                CurrentMusicIndex = ListOfMusics.Count;
            else if (CurrentMusicIndex != 0)
                CurrentMusicIndex -= 1;
            MyMediaElement.Source = new Uri(ListOfMusics[CurrentMusicIndex].file, UriKind.Absolute);
            PlayMedia();
        }

        private void ForwardImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {
            if (CurrentMusicIndex == ListOfMusics.Count)
                CurrentMusicIndex = 0;
            else if (CurrentMusicIndex != ListOfMusics.Count)
                CurrentMusicIndex += 1;
            MyMediaElement.Source = new Uri(ListOfMusics[CurrentMusicIndex].file, UriKind.Absolute);
            PlayMedia();
        }

        private void ToggleButtonMenu_OnChecked(object sender, RoutedEventArgs e)
        {
            PlayButtonToggle.Style = Application.Current.Resources["PauseButtonStyle"] as Style;
            PlayMedia();
            MyDispatcherTimer.Start();
        }

        private void ToggleButtonMenu_OnUnchecked(object sender, RoutedEventArgs e)
        {
            StartTimer();
            PlayButtonToggle.Style = Application.Current.Resources["PlayButtonStyle"] as Style;
            PauseMedia();
        }

        void MyMediaElement_MediaEnded(object sender, RoutedEventArgs e)
        {
            if (CurrentMusicIndex == ListOfMusics.Count)
                CurrentMusicIndex = 0;
            else if (CurrentMusicIndex != ListOfMusics.Count)
                CurrentMusicIndex += 1;
            MyMediaElement.Source = new Uri(ListOfMusics[CurrentMusicIndex].file, UriKind.Absolute);
            PlayMedia();
        }
        #endregion

        #region Shuffle and Repeat Method
        private void ShuffleButtonToggle_OnChecked(object sender, RoutedEventArgs e)
        {

        }

        private void ShuffleButtonToggle_OnUnchecked(object sender, RoutedEventArgs e)
        {

        }

        private void RepeatButtonToggle_OnChecked(object sender, RoutedEventArgs e)
        {

        }

        private void RepeatButtonToggle_OnUnchecked(object sender, RoutedEventArgs e)
        {

        }
        #endregion

        #region BackgroundPlayer

        async void PlayMedia()
        {
            await Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
            {
                MyMediaElement.Play();
            });
        }

        async void PauseMedia()
        {
            await Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
            {
                MyMediaElement.Pause();
            });
        }
        #endregion

        #region Method
        private void TimerOnTick(object sender, object o)
        {
            if (MyMediaElement.NaturalDuration.TimeSpan.Seconds > 0)
            {
                if (MyTimeSpan.TotalSeconds > 0)
                {
                    TimeSlider.Value = MyMediaElement.Position.Seconds;
                }
            }
        }

        private void StartTimer()
        {
            MyTimeSpan = new TimeSpan(MyMediaElement.NaturalDuration.TimeSpan.Seconds);
            MyDispatcherTimer = new DispatcherTimer { Interval = MyTimeSpan };
            MyDispatcherTimer.Tick += TimerOnTick;
            MyDispatcherTimer.Stop();
        }

        private void MyMediaElement_OnMediaOpened(object sender, RoutedEventArgs e)
        {
            StartTimer();
        }
        
        private void HardwareButtonsOnBackPressed(object sender, BackPressedEventArgs backPressedEventArgs)
        {
            backPressedEventArgs.Handled = true;
            _navigationService.GoBack();
        }
        
        #endregion

        #region NotifyPropertyCahnge
        public event PropertyChangedEventHandler PropertyChanged;

        [NotifyPropertyChangedInvocator]
        private void RaisePropertyChanged(string propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }
        #endregion
    }
}
