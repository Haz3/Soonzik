using System;
using System.Collections.Generic;
using System.ComponentModel;
using Windows.Phone.UI.Input;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Input;
using Windows.UI.Xaml.Navigation;
using SoonZik.Annotations;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.ViewModel;

namespace SoonZik.Controls
{
    public sealed partial class PlayerControl : Page, INotifyPropertyChanged
    {
        #region Attribute

        private readonly INavigationService _navigationService;
        private DispatcherTimer _myDispatcherTimer { get; set; }
        private TimeSpan _myTimeSpan { get; set; }

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
        
        #endregion

        #region ctor

        public PlayerControl()
        {
            this.InitializeComponent();
            DataContext = this;
            HardwareButtons.BackPressed += HardwareButtonsOnBackPressed;
            ListOfMusics = new List<Music>();
            ListOfMusics.Add(Singleton.Instance().SelectedMusicSingleton);
        }

        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            PlayedMusic = ListOfMusics[0];
            MyMediaElement.Source = new Uri("ms-appx:///Resources/MusicTest.mp3", UriKind.Absolute);
        }

        #endregion

        #region PlayerButton
        private void RewindImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {

        }

        private void ForwardImage_OnTapped(object sender, TappedRoutedEventArgs e)
        {

        }

        private void ToggleButtonMenu_OnChecked(object sender, RoutedEventArgs e)
        {
            PlayButtonToggle.Style = Application.Current.Resources["PauseButtonStyle"] as Style;

            MyMediaElement.Play();
            _myDispatcherTimer.Start();
        }

        private void ToggleButtonMenu_OnUnchecked(object sender, RoutedEventArgs e)
        {
            StartTimer();
            PlayButtonToggle.Style = Application.Current.Resources["PlayButtonStyle"] as Style;
            MyMediaElement.Pause();
        }

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

        #region Method
        private void TimerOnTick(object sender, object o)
        {
            if (MyMediaElement.NaturalDuration.TimeSpan.Seconds > 0)
            {
                if (_myTimeSpan.TotalSeconds > 0)
                {
                    TimeSlider.Value = MyMediaElement.Position.Seconds;
                }
            }
        }

        private void StartTimer()
        {
            _myTimeSpan = new TimeSpan(MyMediaElement.NaturalDuration.TimeSpan.Seconds);
            _myDispatcherTimer = new DispatcherTimer { Interval = _myTimeSpan };
            _myDispatcherTimer.Tick += TimerOnTick;
            _myDispatcherTimer.Stop();
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
