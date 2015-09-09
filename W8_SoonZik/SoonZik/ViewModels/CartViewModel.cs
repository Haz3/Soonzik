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

namespace SoonZik.ViewModels
{
    class CartViewModel : INotifyPropertyChanged
    {
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

        async public static void buy_cart()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string pack_data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey;

                // HTTP_POST -> URL + DATA
                var response = await request.post_request("purchases/buycart", pack_data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                    await new MessageDialog("Achat du panier OK").ShowAsync();
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
