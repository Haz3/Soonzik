using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class NewsControl : UserControl
    {
        public static readonly DependencyProperty NewsTitleProperty = DependencyProperty.Register(
            "NewsTitle", typeof (string), typeof (NewsControl), new PropertyMetadata(default(string)));

        public string NewsTitle
        {
            get { return (string) GetValue(NewsTitleProperty); }
            set { SetValue(NewsTitleProperty, value); }
        }

        public static readonly DependencyProperty DateNewsProperty = DependencyProperty.Register(
            "DateNews", typeof (string), typeof (NewsControl), new PropertyMetadata(default(string)));

        public string DateNews
        {
            get { return (string) GetValue(DateNewsProperty); }
            set { SetValue(DateNewsProperty, value); }
        }

        public static readonly DependencyProperty ImageNewsProperty = DependencyProperty.Register(
            "ImageNews", typeof (string), typeof (NewsControl), new PropertyMetadata(default(string)));

        public string ImageNews
        {
            get { return (string) GetValue(ImageNewsProperty); }
            set { SetValue(ImageNewsProperty, value); }
        }

        public NewsControl()
        {
            this.InitializeComponent();
        }
    }
}
