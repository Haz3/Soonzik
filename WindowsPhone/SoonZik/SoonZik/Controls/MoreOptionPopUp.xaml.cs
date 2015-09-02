using System.ComponentModel;
using System.Runtime.CompilerServices;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using SoonZik.Annotations;
using SoonZik.HttpRequest.Poco;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class MoreOptionPopUp : UserControl, INotifyPropertyChanged
    {
        #region Attribute

        public static readonly DependencyProperty MusicProperty = DependencyProperty.Register(
            "Music", typeof (Music), typeof (MoreOptionPopUp), new PropertyMetadata(default(Music)));

        public Music SelectedMusic
        {
            get { return (Music) GetValue(MusicProperty); }
            set { SetValue(MusicProperty, value); }
        }
        #endregion

        #region Ctor
        public MoreOptionPopUp(Music theMusic)
        {
            InitializeComponent();
            SelectedMusic = theMusic;
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
    }
}