using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using Windows.UI.Popups;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using System.Net;

namespace SoonZik.ViewModels
{
    class ConcertViewModel
    {
        public ObservableCollection<Concert> concertlist { get; set; }

        public ConcertViewModel()
        {
            load_concert();
        }

        async void load_concert()
        {
            Exception exception = null;
            concertlist = new ObservableCollection<Concert>();

            try
            {
                var concert = (List<Concert>)await Http_get.get_object(new List<Concert>(), "concerts");

                foreach (var item in concert)
                {
                    item.address = await geocode(item.address);
                    concertlist.Add(item);
                }
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Concert error").ShowAsync();
        }

        async Task<Address> geocode(Address addr)
        {
            HttpClient client = new HttpClient();
            Exception exception = null;

            string address = addr.numberStreet.ToString() + " " + addr.street + " " + addr.zipcode;
            string url = "http://maps.google.com/maps/api/geocode/json?address=" + WebUtility.UrlEncode(address);

            try
            {
                var data = await client.GetStringAsync(url);
                var result = JObject.Parse(data);

                var lat = result["results"][0]["geometry"]["location"]["lat"];
                var lng = result["results"][0]["geometry"]["location"]["lng"];

                addr.lat = lat.ToString().Replace(",", ".");
                addr.lng = lng.ToString().Replace(",", ".");
                return addr;
            }
            catch (Exception e)
            {
                exception = e;
            }
            if (exception != null)
                await new MessageDialog(exception.Message, "Concert geocode error").ShowAsync();
            return addr;
        }
    }
}
