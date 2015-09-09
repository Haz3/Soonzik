using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.ViewModel;
using SoonZik.Views;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class PriceControl : UserControl
    {
        #region Ctor

        public PriceControl()
        {
            InitializeComponent();

            AssoBool = false;
            SoonBool = false;
            ArtisBool = false;

            InitializePrice();
        }

        #endregion

        #region Slider
        private void AssociationSlider_OnManipulationDelta(object sender, RangeBaseValueChangedEventArgs e)
        {
            if (e.NewValue < 10)
            {
                ArtistePriceCalc(e.NewValue);
                SoonZikPriceCalc(e.NewValue);
            }
        }

        private void ArtistSlider_OnManipulationDelta(object sender, RangeBaseValueChangedEventArgs e)
        {
            if (e.NewValue < 10)
            {
                AssociationPriceCalc(e.NewValue);
                SoonZikPriceCalc(e.NewValue);
            }
        }

        private void SoonZikSlider_OnManipulationDelta(object sender, RangeBaseValueChangedEventArgs e)
        {
            if (e.NewValue < 10)
            {
                ArtistePriceCalc(e.NewValue);
                AssociationPriceCalc(e.NewValue);
            }
        }

        private void ArtistSlider_OnGotFocus(object sender, RoutedEventArgs e)
        {
            if (ArtistSlider.Value < 10)
            {
                AssociationPriceCalc(ArtistSlider.Value);
                SoonZikPriceCalc(ArtistSlider.Value);
            }
        }
        #endregion

        #region Attribute
        private string _cryptographic { get; set; }
        public static Pack SelecetdPack { get; set; }
        private bool AssoBool { get; set; }
        private bool SoonBool { get; set; }
        private bool ArtisBool { get; set; }

        #endregion

        #region Method

        private void InitializePrice()
        {
            //if (SelecetdPack.averagePrice != 0)
            PriceTextBox.Text = SelecetdPack.averagePrice;
            //else
            //{
            //    SelecetdPack.averagePrice = "10";
            //    PriceTextBox.Text = SelecetdPack.price;
            //}


            ArtistSlider.Maximum = Convert.ToDouble(SelecetdPack.averagePrice);
            AssociationSlider.Maximum = Convert.ToDouble(SelecetdPack.averagePrice);
            SoonZikSlider.Maximum = Convert.ToDouble(SelecetdPack.averagePrice);

            ArtistePriceCalc(Convert.ToDouble(SelecetdPack.averagePrice));
            AssociationPriceCalc(Convert.ToDouble(SelecetdPack.averagePrice));
            SoonZikPriceCalc(Convert.ToDouble(SelecetdPack.averagePrice));
        }

        private void ArtistePriceCalc(double price)
        {
            ArtistSlider.Value = (price * 70) / 100;
        }

        private void AssociationPriceCalc(double price)
        {
            AssociationSlider.Value = (price * 20) / 100;
        }

        private void SoonZikPriceCalc(double price)
        {
            SoonZikSlider.Value = (price * 10) / 100;
        }

        #endregion

        private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
        {
            new MessageDialog("En cours de dev").ShowAsync();
        }
    }
}