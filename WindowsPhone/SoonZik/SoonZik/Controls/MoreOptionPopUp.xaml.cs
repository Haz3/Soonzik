using System.ComponentModel;
using System.Runtime.CompilerServices;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using SoonZik.Annotations;
using SoonZik.HttpRequest.Poco;
using SoonZik.ViewModel;
using SoonZik.Views;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class MoreOptionPopUp : UserControl, INotifyPropertyChanged
    {
        #region Ctor

        public MoreOptionPopUp(Music theMusic)
        {
            InitializeComponent();
            SelectedMusic = theMusic;
            TitleBlock.Text = SelectedMusic.title;
        }

        #endregion

        #region Attribute

        public static readonly DependencyProperty SelectedMusicProperty = DependencyProperty.Register(
            "SelectedMusic", typeof (Music), typeof (MoreOptionPopUp), new PropertyMetadata(default(Music)));

        public Music SelectedMusic
        {
            get { return (Music) GetValue(SelectedMusicProperty); }
            set { SetValue(SelectedMusicProperty, value); }
        }

        #endregion

        #region INotifyPropertyChange

        public event PropertyChangedEventHandler PropertyChanged;

        [NotifyPropertyChangedInvocator]
        private void RaisePropertyChange([CallerMemberName] string propertyName = null)
        {
            var handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }

        #endregion

        private void AddToPlaylist(object sender, RoutedEventArgs e)
        {
            MyMusicViewModel.MusicForPlaylist = SelectedMusic;
            MyMusicViewModel.IndexForPlaylist = 3;
            GlobalMenuControl.SetChildren(new MyMusic());
            AlbumViewModel.MessagePrompt.Hide();
        }
    }
}