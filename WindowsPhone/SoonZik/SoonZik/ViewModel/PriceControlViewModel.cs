using System;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class PriceControlViewModel : ViewModelBase
    {
        #region Ctor

        public PriceControlViewModel()
        {
            ArtisteSliderCommand = new RelayCommand(ArtisteSliderExecute);
            AssocSliderCommand = new RelayCommand(AssocSliderExecute);
            SoonZikSliderCommand = new RelayCommand(SoonzikSliderExecute);
            BuyCommand = new RelayCommand(BuyExecute);
            ThePack = SelecetdPack;
            InitializePrice();
        }

        #endregion

        #region Attribute

        public static Pack SelecetdPack { get; set; }

        private Pack _thePack;

        public Pack ThePack
        {
            get { return _thePack; }
            set
            {
                _thePack = value;
                RaisePropertyChanged("ThePack");
            }
        }

        public ICommand BuyCommand { get; private set; }
        public ICommand ArtisteSliderCommand { get; private set; }
        public ICommand AssocSliderCommand { get; private set; }
        public ICommand SoonZikSliderCommand { get; private set; }

        private double _artsiteSliderValue;

        public double ArtisteSliderValue
        {
            get { return _artsiteSliderValue; }
            set
            {
                _artsiteSliderValue = value;
                RaisePropertyChanged("ArtisteSliderValue");
            }
        }

        private double _assocSliderValue;

        public double AssocSliderValue
        {
            get { return _assocSliderValue; }
            set
            {
                _assocSliderValue = value;
                RaisePropertyChanged("AssocSliderValue");
            }
        }

        private double _soonzikSliderValue;

        public double SoonzikSliderValue
        {
            get { return _soonzikSliderValue; }
            set
            {
                _soonzikSliderValue = value;
                RaisePropertyChanged("SoonzikSliderValue");
            }
        }

        private string _artsitePrice;

        public string ArtistePrice
        {
            get { return _artsitePrice; }
            set
            {
                _artsitePrice = value;
                RaisePropertyChanged("ArtistePrice");
            }
        }

        private string _assocPrice;

        public string AssocPrice
        {
            get { return _assocPrice; }
            set
            {
                _assocPrice = value;
                RaisePropertyChanged("AssocPrice");
            }
        }

        private string _soonzikPrice;

        public string SoonzikPrice
        {
            get { return _soonzikPrice; }
            set
            {
                _soonzikPrice = value;
                RaisePropertyChanged("SoonzikPrice");
            }
        }

        #endregion

        #region Method

        private void InitializePrice()
        {
            ArtisteSliderValue = 65;
            AssocSliderValue = 20;
            SoonzikSliderValue = 15;
            ArtistePriceCalc();
            SoonZikPriceCalc();
            AssociationPriceCalc();
        }

        private void BuyExecute()
        {
            new MessageDialog("En cours de dev").ShowAsync();
            var post = new HttpRequestPost();

            ValidateKey.GetValideKey();
            var res = post.PurchasePack(SelecetdPack.id, Double.Parse(ThePack.averagePrice), ArtisteSliderValue,
                AssocSliderValue, SoonzikSliderValue, Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser);
            res.ContinueWith(delegate(Task<string> tmp2)
            {
                var res2 = tmp2.Result;
                if (res2 != null)
                {
                    var message = (ErrorMessage) JsonConvert.DeserializeObject(res2, typeof (ErrorMessage));
                    if (message.code != 201)
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { new MessageDialog("Erreur lors du paiement").ShowAsync(); });
                    else
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { new MessageDialog("paiement effectue").ShowAsync(); });
                }
            });
        }

        private void ArtistePriceCalc()
        {
            ArtistePrice = ((Convert.ToDouble(ThePack.averagePrice)*ArtisteSliderValue/100)).ToString();
        }

        private void AssociationPriceCalc()
        {
            AssocPrice = ((Convert.ToDouble(ThePack.averagePrice)*AssocSliderValue/100)).ToString();
        }

        private void SoonZikPriceCalc()
        {
            SoonzikPrice = ((Convert.ToDouble(ThePack.averagePrice)*SoonzikSliderValue/100)).ToString();
        }

        private void AssocSliderExecute()
        {
            ArtisteSliderValue = (100 - AssocSliderValue);
            SoonzikSliderValue = (ArtisteSliderValue*15)/100;

            ArtistePriceCalc();
            AssociationPriceCalc();
            SoonZikPriceCalc();
        }

        private void SoonzikSliderExecute()
        {
            ArtisteSliderValue = (100 - SoonzikSliderValue);
            AssocSliderValue = (ArtisteSliderValue*20)/100;

            ArtistePriceCalc();
            AssociationPriceCalc();
            SoonZikPriceCalc();
        }

        private void ArtisteSliderExecute()
        {
            AssocSliderValue = (100 - ArtisteSliderValue);
            SoonzikSliderValue = (AssocSliderValue*15)/100;

            ArtistePriceCalc();
            AssociationPriceCalc();
            SoonZikPriceCalc();
        }

        #endregion
    }
}