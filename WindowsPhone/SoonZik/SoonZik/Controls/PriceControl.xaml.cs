using System;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Input;
using SoonZik.HttpRequest.Poco;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class PriceControl : UserControl
    {
        #region Attribute
        public static Pack SelecetdPack { get; set; }
        #endregion

        #region Ctor
        public PriceControl()
        {
            this.InitializeComponent();

            InitializePrice();
        }
        #endregion

        #region Method

        private void InitializePrice()
        {
            if (SelecetdPack.price != null)
                PriceTextBox.Text = SelecetdPack.price;
            else
            {
                SelecetdPack.price = "10";
                PriceTextBox.Text = SelecetdPack.price;
            }
                

            ArtistSlider.Maximum = Convert.ToDouble(SelecetdPack.price);
            AssociationSlider.Maximum = Convert.ToDouble(SelecetdPack.price);
            SoonZikSlider.Maximum = Convert.ToDouble(SelecetdPack.price);

            ArtistePriceCalc(Convert.ToDouble(SelecetdPack.price));
            AssociationPriceCalc(Convert.ToDouble(SelecetdPack.price));
            SoonZikPriceCalc(Convert.ToDouble(SelecetdPack.price));

        }

        private void ArtistePriceCalc(double price)
        {
            ArtistSlider.Value = (price*70)/100;
        }

        private void AssociationPriceCalc(double price)
        {
            AssociationSlider.Value = (price * 20) / 100;
        }

        private void SoonZikPriceCalc(double price)
        {
            SoonZikSlider.Value = (price* 10) / 100;
        }

        #endregion

        private void AssociationSlider_OnManipulationDelta(object sender, ManipulationDeltaRoutedEventArgs e)
        {
            if (e.Position.X < 10)
            {
                ArtistePriceCalc(e.Position.X);
                SoonZikPriceCalc(e.Position.X);
            }
        }

        private void ArtistSlider_OnManipulationDelta(object sender, ManipulationDeltaRoutedEventArgs e)
        {
            if (e.Position.X < 10)
            {
                AssociationPriceCalc(e.Position.X);
                SoonZikPriceCalc(e.Position.X);
            }
        }

        private void SoonZikSlider_OnManipulationDelta(object sender, ManipulationDeltaRoutedEventArgs e)
        {
            if (e.Position.X < 10)
            {
                ArtistePriceCalc(e.Position.X);
                AssociationPriceCalc(e.Position.X);
            }
        }
    }
}
