using System;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Primitives;
using Newtonsoft.Json;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

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

        private void ButtonBase_OnClick(object sender, RoutedEventArgs e)
        {
            new MessageDialog("En cours de dev").ShowAsync(); 
            var request = new HttpRequestGet();
            var post = new HttpRequestPost();
            _cryptographic = "";
            var userKey2 = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            userKey2.ContinueWith(delegate(Task<object> task2)
            {
                var key2 = task2.Result as string;
                if (key2 != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key2);
                    _cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt + stringEncrypt);
                }
                var res = post.PurchasePack(SelecetdPack.id, Double.Parse(PriceTextBox.Text), ArtistSlider.Value, AssociationSlider.Value, SoonZikSlider.Value, _cryptographic, Singleton.Singleton.Instance().CurrentUser);
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var res2 = tmp2.Result;
                    if (res2 != null)
                    {
                        var message = (ErrorMessage)JsonConvert.DeserializeObject(res2, typeof(ErrorMessage));
                        if (message.code != 201)
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () => { new MessageDialog("Erreur lors du paiement").ShowAsync(); });
                        else
                            CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                                () => { new MessageDialog("paiement effectue").ShowAsync(); });

                    }
                });
            });
        }

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
            ArtistSlider.Value = (price*70)/100;
        }

        private void AssociationPriceCalc(double price)
        {
            AssociationSlider.Value = (price*20)/100;
        }

        private void SoonZikPriceCalc(double price)
        {
            SoonZikSlider.Value = (price*10)/100;
        }

        #endregion
    }
}