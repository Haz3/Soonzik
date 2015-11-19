using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Threading;
using System.Windows;
using System.Windows.Forms;
using NAudio.CoreAudioApi;
using NAudio.Wave;
using SoonZik.Streaming.View;

namespace SoonZik.Streaming
{
    /// <summary>
    /// Logique d'interaction pour MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window, INotifyPropertyChanged
    {
        #region Attributes

        public MMDevice SelectedDevice;
        public IEnumerable<MMDevice> CaptureDevices { get; private set; }
        public static Window ConnectionWindow;
        WaveIn sourceStream;
        DirectSoundOut waveOut;
        WaveFileWriter waveWriter;
        private readonly SynchronizationContext synchronizationContext;
        private float peak;
        public float Peak
        {
            get { return peak; }
            set
            {
                // ReSharper disable once CompareOfFloatsByEqualityOperator
                if (peak != value)
                {
                    peak = value;
                    OnPropertyChanged("Peak");
                }
            }
        }
        #endregion

        #region Ctor

        public MainWindow()
        {
            synchronizationContext = SynchronizationContext.Current;
            DataContext = this;
            RunConnexion();

            var enumerator = new MMDeviceEnumerator();
            CaptureDevices = enumerator.EnumerateAudioEndPoints(DataFlow.Capture, DeviceState.Active).ToArray();
            InitializeComponent();
        }

        #endregion

        #region Method Connexion

        private void RunConnexion()
        {
            ConnectionWindow = new Window();
            ConnectionWindow.Width = 525;
            ConnectionWindow.Height = 380;
            ConnectionWindow.ResizeMode = ResizeMode.NoResize;
            ConnectionWindow.Content = new Connexion();
            ConnectionWindow.Show();
            ConnectionWindow.Closed += ConnectionWindow_Closed;
        }

        private void ConnectionWindow_Closed(object sender, EventArgs e)
        {
            WelcomeTextBlock.Text = "Bonjour " + Singleton.Singleton.Instance().TheArtiste.username;
            CheckDevice();
        }
        #endregion

        #region Method Record
        private void CheckDevice()
        {
            DevicesListBox.ItemsSource = CaptureDevices;
        }

        private void ChooseDevice_OnClick(object sender, RoutedEventArgs e)
        {
            List<WaveInCapabilities> sources = new List<WaveInCapabilities>();

            /*for (int i = 0; i < WaveIn.DeviceCount; i++)
            {
                sources.Add(WaveIn.GetCapabilities(i));
            }

            DevicesListBox.Items.Clear();

            foreach (var source in sources)
            {
                DevicesListBox.Items.Add(source);
            }*/
        }
        private float recordLevel;
        public float RecordLevel
        {
            get { return recordLevel; }
            set
            {
                // ReSharper disable once CompareOfFloatsByEqualityOperator
                if (recordLevel != value)
                {
                    recordLevel = value;
                    if (sourceStream != null)
                    {
                        SelectedDevice.AudioEndpointVolume.MasterVolumeLevelScalar = value;
                    }
                    OnPropertyChanged("RecordLevel");
                }
            }
        }

        private void StartRecord_OnClick(object sender, RoutedEventArgs e)
        {
            if (DevicesListBox.SelectedItems.Count == 0) return;

            SaveFileDialog save = new SaveFileDialog();
            save.Filter = "Wave File (*.wav)|*.wav;";
            if (save.ShowDialog() != System.Windows.Forms.DialogResult.OK) return;
            
            int deviceNumber = DevicesListBox.SelectedIndex;
            SelectedDevice = (MMDevice) DevicesListBox.SelectedItem;
            sourceStream = new WaveIn();
            sourceStream.DeviceNumber = deviceNumber;
            sourceStream.WaveFormat = new WaveFormat(44100, WaveIn.GetCapabilities(deviceNumber).Channels);
            RecordLevel = SelectedDevice.AudioEndpointVolume.MasterVolumeLevelScalar;
            sourceStream.DataAvailable += sourceStream_DataAvailable;
            waveWriter = new WaveFileWriter(save.FileName, sourceStream.WaveFormat);

            sourceStream.StartRecording();
        }
        
        private void StopRecord_OnClick(object sender, RoutedEventArgs e)
        {
            if (waveOut != null)
            {
                waveOut.Stop();
                waveOut.Dispose();
                waveOut = null;
            }
            if (sourceStream != null)
            {
                sourceStream.StopRecording();
                sourceStream.Dispose();
                sourceStream = null;
            }
            if (waveWriter != null)
            {
                waveWriter.Dispose();
                waveWriter = null;
            }
        }

        private void sourceStream_DataAvailable(object sender, WaveInEventArgs e)
        {
            if (waveWriter == null) return;

            waveWriter.Write(e.Buffer, 0, e.BytesRecorded);
            waveWriter.Flush();
            UpdatePeakMeter();
        }

        void UpdatePeakMeter()
        {
            // can't access this on a different thread from the one it was created on, so get back to GUI thread
            synchronizationContext.Post(s => Peak = SelectedDevice.AudioMeterInformation
                .MasterPeakValue, null);
            ProgressBarVolume.Value = Peak;
        }
        #endregion

        #region INotify
        public event PropertyChangedEventHandler PropertyChanged;

        protected virtual void OnPropertyChanged(string propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }
        #endregion

    }
}
