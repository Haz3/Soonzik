using Windows.UI.Xaml.Controls;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class PivotControl : UserControl
    {
        #region Attribute
        public static Pivot MyPivot { get; set; }

        #endregion


        #region Ctor
        public PivotControl()
        {
            this.InitializeComponent();
            MyPivot = PivotGlobal;
        }

        #endregion
    }
}
