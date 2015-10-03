using Newtonsoft.Json.Linq;
using SoonZik.Tools;
using SoonZik.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;
using System.ComponentModel;
using System.Collections.ObjectModel;
using Windows.UI.Xaml;
using System.Windows.Input;
using SoonZik.Common;
using PayPal.Checkout;
using PayPal;

namespace SoonZik.ViewModels
{
    class CartViewModel : INotifyPropertyChanged
    {
        private string _txt_pp;
        public string txt_pp
        {
            get { return _txt_pp; }
            set
            {
                _txt_pp = value;
                OnPropertyChanged("txt_pp");
            }
        }

        public string pp_transac_id { get; set; }


        private Cart _cart;
        public Cart cart
        {
            get { return _cart; }
            set
            {
                _cart = value;
                OnPropertyChanged("cart");
            }
        }

        public ObservableCollection<Cart> list_cart { get; set; }

        private Visibility _album_visibility;
        public Visibility album_visibility
        {
            get { return _album_visibility; }
            set
            {
                _album_visibility = value;
                OnPropertyChanged("album_visibility");
            }
        }

        private Visibility _music_visibility;
        public Visibility music_visibility
        {
            get { return _music_visibility; }
            set
            {
                _music_visibility = value;
                OnPropertyChanged("music_visibility");
            }
        }

        public ICommand do_remove_cart
        {
            get;
            private set;
        }
        public ICommand do_buy_cart
        {
            get;
            private set;
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        public CartViewModel()
        {
            do_buy_cart = new RelayCommand(buy_cart);
            do_remove_cart = new RelayCommand(remove_cart);
            load_cart();
        }

        public async void load_cart()
        {
            Exception exception = null;
            list_cart = new ObservableCollection<Cart>();
            music_visibility = Visibility.Visible;
            album_visibility = Visibility.Visible;

            try
            {
                var list = (List<Cart>)await Http_get.get_object(new List<Cart>(), "carts/my_cart?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));
                foreach (var item in list)
                    list_cart.Add(item);
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Cart load error").ShowAsync();
        }

        async public static void add_to_cart(int user_id, int obj_id, string obj_type, int gift_user_id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string pack_data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&cart[user_id]=" + user_id +
                    "&cart[typeObj]=" + obj_type +
                    "&cart[obj_id]=" + obj_id;

                if (gift_user_id > 0)
                    pack_data += "&gift_user_id=" + gift_user_id;

                // HTTP_POST -> URL + DATA
                var response = await request.post_request("carts/save", pack_data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    await new MessageDialog("Cart add OK").ShowAsync();
                }
                else
                    await new MessageDialog(json.ToString(), "Cart add KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "cart add error").ShowAsync();
        }

        async public void remove_cart()
        {
            Exception exception = null;

            try
            {
                var ret = await Http_get.get_data("carts/destroy?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()) + "&id=" + cart.id.ToString());
                list_cart.Remove(cart);
                await new MessageDialog("code = " + ret, "remove cart OK").ShowAsync();
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "remove cart error").ShowAsync();
        }

        async public void buy_cart()
        {

            //buy_cart_after_pp_validation();

            PayPal.Checkout.BuyNow purchase = new PayPal.Checkout.BuyNow("test_sz_merchant@gmail.com");
            purchase.UseSandbox = true;

            purchase.Currency = "EUR";

            // Use the ItemBuilder to create a new example item
            PayPal.Checkout.ItemBuilder itemBuilder = new PayPal.Checkout.ItemBuilder("Example Item")
                .ID("test_250")
                .Price("2.50")
                .Description("the item i want to buy loooooooooooool")
                .Quantity(1);

            // Add the item to the purchase,
            purchase.AddItem(itemBuilder.Build());

            // Attach event handlers so you will be notified of important events
            // The BuyNow interface provides 5 events - Start, Auth, Cancel, Complete and Error
            // See http://paypal.github.io/Windows8SDK/csharp.html#Events for more
            purchase.Error += new EventHandler<PayPal.Checkout.Event.ErrorEventArgs>((source, eventArg) =>
            {
                this.txt_pp = "There was an error processing your payment: " + eventArg.Message;
            });
            purchase.Auth += new EventHandler<PayPal.Checkout.Event.AuthEventArgs>((source, eventArg) =>
            {
                this.txt_pp = "Auth" + eventArg.Token;
            });
            purchase.Start += new EventHandler<PayPal.Checkout.Event.StartEventArgs>((source, eventArg) =>
            {
                this.txt_pp = "Start";
            });
            purchase.Complete += new EventHandler<PayPal.Checkout.Event.CompleteEventArgs>((source, eventArg) =>
            {
                //buy_cart_after_pp_validation();
                this.txt_pp = "Payment is complete. Transaction id: " + eventArg.TransactionID;
                this.pp_transac_id = eventArg.TransactionID;
                this.buy_cart_after_pp_validation();
            });
            purchase.Cancel += new EventHandler<PayPal.Checkout.Event.CancelEventArgs>((source, eventArg) =>
            {
                this.txt_pp = "Payment was canceled by the user.";
            });

            // Launch the secure PayPal interface. This is an asynchronous method
            await purchase.Execute();

        }

        async public void buy_cart_after_pp_validation()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string pack_data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&paypal[payment_id]=" + pp_transac_id +
                    "&paypal[payment_method]=" + "pp" +
                    "&paypal[status]=" + "lol_status" +
                    "&paypal[payer_email]=" + "test@test.test" +
                    "&paypal[payer_first_name]=" + "roger" +
                    "&paypal[payer_last_name]=" + "jean_michel" +
                    "&paypal[payer_id]=" + "1337" +
                    "&paypal[payer_phone]=" + "0606060606" +
                    "&paypal[payer_country_code]=" + "FR" +
                    "&paypal[payer_street]=" + "69" +
                    "&paypal[payer_city]=" + "Parise" +
                    "&paypal[payer_postal_code]=" + "75000" +
                    //"&paypal[payer_country_code]=" + "FR" +
                    "&paypal[payer_recipient_name]=" + "robert";


                // HTTP_POST -> URL + DATA
                var response = await request.post_request("purchases/buycart", pack_data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    // empty cart
                    list_cart = null;
                    await new MessageDialog("Achat du panier OK").ShowAsync();
                }
                else
                    await new MessageDialog("Achat du panier KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Achat du panier error").ShowAsync();
        }
    }
}
