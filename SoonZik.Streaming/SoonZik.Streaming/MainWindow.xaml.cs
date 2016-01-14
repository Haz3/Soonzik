﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Threading;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Windows.Threading;
using NAudio.CoreAudioApi;
using NAudio.MediaFoundation;
using NAudio.Wave;
using SoonZik.Streaming.Utils;
using SoonZik.Streaming.View;
using MessageBox = System.Windows.Forms.MessageBox;
using System.Net;
using System.IO;
using SonnZik.Streaming.HttpWebRequest;

namespace SoonZik.Streaming
{
    /// <summary>
    /// Logique d'interaction pour MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window, INotifyPropertyChanged
    {
        #region Attributes

        private int sampleRate;
        public int SampleRate
        {
            get
            {
                return sampleRate;
            }
            set
            {
                if (sampleRate != value)
                {
                    sampleRate = value;
                    OnPropertyChanged("SampleRate");
                }
            }
        }

        private int bitDepth;

        public int BitDepth
        {
            get
            {
                return bitDepth;
            }
            set
            {
                if (bitDepth != value)
                {
                    bitDepth = value;
                    OnPropertyChanged("BitDepth");
                }
            }
        }

        public int sampleTypeIndex;
        public int SampleTypeIndex
        {
            get
            {
                return sampleTypeIndex;
            }
            set
            {
                if (sampleTypeIndex != value)
                {
                    sampleTypeIndex = value;
                    OnPropertyChanged("SampleTypeIndex");
                    BitDepth = sampleTypeIndex == 1 ? 16 : 32;
                    OnPropertyChanged("IsBitDepthConfigurable");
                }
            }
        }

        private int channelCount;
        public int ChannelCount
        {
            get
            {
                return channelCount;
            }
            set
            {
                if (channelCount != value)
                {
                    channelCount = value;
                    OnPropertyChanged("ChannelCount");
                }
            }
        }

        public bool IsBitDepthConfigurable
        {
            get
            {
                return SampleTypeIndex == 1;
            }
        }
        private string _fileLocation;
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
        #endregion

        #region Ctor

        public MainWindow()
        {
            InitializeComponent();
            DataContext = this;
            synchronizationContext = SynchronizationContext.Current;
            var enumerator = new MMDeviceEnumerator();
            CaptureDevices = enumerator.EnumerateAudioEndPoints(DataFlow.Capture, DeviceState.Active).ToArray();
            RunConnexion();
        }

        #endregion

        #region Method Connexion
        /*
         * Lance la fenetre de connexion
         */
        private void RunConnexion()
        {
            ConnectionWindow = new Window();
            ConnectionWindow.Width = 525;
            ConnectionWindow.Height = 380;
            ConnectionWindow.ResizeMode = ResizeMode.NoResize;
            ConnectionWindow.Title = "Connection";
            ConnectionWindow.Content = new Connexion();
            ConnectionWindow.Show();
            ConnectionWindow.Closed += ConnectionWindow_Closed;
        }

        /*
         * Ferme la fenetre de connexion, et appel la fonction pour recuperer les devices
         */
        private void ConnectionWindow_Closed(object sender, EventArgs e)
        {
            if (Singleton.Singleton.Instance().TheArtiste == null) return;
            var username = Singleton.Singleton.Instance().TheArtiste.username;
            if (username != null)
                WelcomeTextBlock.Text = "Bonjour " + username;
            CheckDevice();
        }

        #endregion

        #region Method Record
        /*
         * Recupere les devices d'entrer micro
         */
        private void CheckDevice()
        {
            DevicesListBox.ItemsSource = CaptureDevices;

            using (var c = new WasapiCapture((MMDevice) CaptureDevices.First()))
            {
                SampleTypeIndex = c.WaveFormat.Encoding == WaveFormatEncoding.IeeeFloat ? 0 : 1;
                SampleRate = c.WaveFormat.SampleRate;
                BitDepth = c.WaveFormat.BitsPerSample;
                ChannelCount = c.WaveFormat.Channels;
            }
        }

        /*
         * Creation du fichier, plus lancement du record
         */
        private void StartRecord_OnClick(object sender, RoutedEventArgs e)
        {
            if (DevicesListBox.SelectedItems.Count == 0)
            {
                var result = (MessageBoxResult)MessageBox.Show("Veuillez selectioner un device", "Erreur");
                return;
            }

            SaveFileDialog save = new SaveFileDialog();
            save.Filter = "Wave File (*.wav)|*.wav;";
            if (save.ShowDialog() != System.Windows.Forms.DialogResult.OK) return;
            _fileLocation = save.InitialDirectory + save.FileName;
            int deviceNumber = DevicesListBox.SelectedIndex;
            SelectedDevice = (MMDevice)DevicesListBox.SelectedItem;
            sourceStream = new WaveIn();

            sourceStream.DeviceNumber = deviceNumber;
            sourceStream.WaveFormat = SampleTypeIndex == 0 ? WaveFormat.CreateIeeeFloatWaveFormat(sampleRate, channelCount) :
                    new WaveFormat(sampleRate, bitDepth, channelCount);
            RecordLevel = SelectedDevice.AudioEndpointVolume.MasterVolumeLevelScalar;
            SliderVolume.Value = RecordLevel;
            sourceStream.DataAvailable += sourceStream_DataAvailable;
            waveWriter = new WaveFileWriter(save.FileName, sourceStream.WaveFormat);

            sourceStream.StartRecording();
        }

        /*
         * Cloture le record
         */
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
            ProgressBarVolume.Value = 0;
            Encode();
            var result = (MessageBoxResult)MessageBox.Show("Enregistrement termine", "Enregistrement");
        }

        /*
         * Ecrit dans le fichier
         */
        private void sourceStream_DataAvailable(object sender, WaveInEventArgs e)
        {
            if (waveWriter == null) return;

            waveWriter.Write(e.Buffer, 0, e.BytesRecorded);
            waveWriter.Flush();
            UpdatePeakMeter();
        }

        /*
         * Permet de mettre a jour le volume entrant du micro
         */
        void UpdatePeakMeter()
        {
            synchronizationContext.Post(s => Peak = SelectedDevice.AudioMeterInformation.MasterPeakValue, null);
            ProgressBarVolume.Value = Peak;
        }

        /*
         * Permet de gerer le son du micro
         */
        private void SliderVolume_OnValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            var value = (Slider)e.OriginalSource;
            SelectedDevice.AudioEndpointVolume.MasterVolumeLevelScalar = (float)value.Value;
        }

        private void Encode()
        {
            using (var reader = new MediaFoundationReader(_fileLocation))
            {
                var SelectedOutputFormat = new Encoder()
                {
                    Name = "MP3",
                    Guid = AudioSubtypes.MFAudioFormat_MP3,
                    Extension = ".mp3"
                };
                var list = MediaFoundationEncoder.GetOutputMediaTypes(SelectedOutputFormat.Guid)
                                  .Select(mf => new MediaTypeUtils(mf))
                                  .ToList();
                string outputUrl = SelectSaveFile();
                if (outputUrl == null) return;
                using (var encoder = new MediaFoundationEncoder(list[0].MediaType))
                {
                    encoder.Encode(outputUrl, reader);
                }
            }
        }

        private string SelectSaveFile()
        {
            var sfd = new SaveFileDialog { FileName = _fileLocation + " converted" + ".mp3", Filter = "MP3|*.mp3" };
            //return (sfd.ShowDialog() == true) ? new Uri(sfd.FileName).AbsoluteUri : null;
            return sfd.FileName;
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

        private void choose_file_btn_Click(object sender, RoutedEventArgs e)
        {
            Microsoft.Win32.OpenFileDialog dlg = new Microsoft.Win32.OpenFileDialog();

            dlg.DefaultExt = ".wav";
            dlg.Filter = "WAV Files (*.WAV)|*.wav"; 


            // Display OpenFileDialog by calling ShowDialog method 
            Nullable<bool> result = dlg.ShowDialog();


            // Get the selected file name and display in a TextBox 
            if (result == true)
            {
                // Open document 
                string filename = dlg.FileName;
                upload_file_name_txt.Text = filename;
            }
        }

        private async void upload_btn_Click(object sender, RoutedEventArgs e)
        {
            string ArtistUrl = "http://artist.lvh.me:3000/";

            // creating request
            HttpWebRequestPost post = new HttpWebRequestPost();
            var request = (HttpWebRequest)WebRequest.Create(ArtistUrl + "/musics/uploadRediff");

            string filename = System.IO.Path.GetFileName(upload_file_name_txt.Text);

            Byte[] bytes = File.ReadAllBytes(upload_file_name_txt.Text);
            String file = Convert.ToBase64String(bytes);


            string postData = "filename=" + filename
                                + "&data=" + file // file.Substring(0, 4000)
                                + "&user_id=" + Singleton.Singleton.Instance().TheArtiste.id.ToString()
                                + "&secureKey=" + Security.getSecureKey(Singleton.Singleton.Instance().TheArtiste.id.ToString());
           await post.GetHttpPostResponse(request, postData);

        }
    }

    internal class Encoder
    {
        public string Name { get; set; }
        public Guid Guid { get; set; }
        public string Extension { get; set; }
    }
}
