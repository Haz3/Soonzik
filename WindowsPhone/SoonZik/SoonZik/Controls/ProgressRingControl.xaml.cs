using System.ComponentModel;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class ProgressRingControl : UserControl
    {
        public static readonly DependencyProperty GridVisibilityProperty = DependencyProperty.Register(
            "GridVisibility", typeof (Visibility), typeof (ProgressRingControl), new PropertyMetadata(default(Visibility)));

        public Visibility GridVisibility
        {
            get { return (Visibility) GetValue(GridVisibilityProperty); }
            set { SetValue(GridVisibilityProperty, value); }
        }

        public static readonly DependencyProperty isActiveProperty = DependencyProperty.Register(
            "isActive", typeof (bool), typeof (ProgressRingControl), new PropertyMetadata(default(bool)));

        public bool isActive
        {
            get { return (bool) GetValue(isActiveProperty); }
            set { SetValue(isActiveProperty, value); }
        }
        
        public ProgressRingControl()
        {
            this.InitializeComponent();
            DataContext = this;
        }
    }
}
