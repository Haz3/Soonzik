using System.Collections.Generic;
using System.Windows;
using NAudio.Wave;
using SoonZik.Streaming.View;

namespace SoonZik.Streaming
{
    /// <summary>
    /// Logique d'interaction pour MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        #region Attributes

        public static Window ConnectionWindow;
        public List<WaveInCapabilities> listDevice; 

        #endregion

        #region Ctor

        public MainWindow()
        {
            RunConnexion();
            InitializeComponent();
        }

        #endregion

        #region Method

        private void RunConnexion()
        {
            ConnectionWindow = new Window();
            ConnectionWindow.Width = 525;
            ConnectionWindow.Height = 380;
            ConnectionWindow.ResizeMode = System.Windows.ResizeMode.NoResize;
            ConnectionWindow.Content = new Connexion();
            ConnectionWindow.Show();
            ConnectionWindow.Closed += ConnectionWindow_Closed;
        }

        private void ConnectionWindow_Closed(object sender, System.EventArgs e)
        {
            WelcomeTextBlock.Text = "Bonjour " + Singleton.Singleton.Instance().TheArtiste.username;
            CheckDevice();
        }

        private void CheckDevice()
        {
            listDevice = new List<WaveInCapabilities>();
            int waveInDevice = WaveIn.DeviceCount;
            for (int i = 0; i < waveInDevice; i++)
            {
                WaveInCapabilities deviceInfo = WaveIn.GetCapabilities(i);
                listDevice.Add(deviceInfo);
            }
        }

    #endregion
    }
}
