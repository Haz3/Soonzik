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
            var request = new Http_get();
            concertlist = new ObservableCollection<Concert>();
            List<Concert> list = new List<Concert>();

            //Get_coordinates geocode = new Get_coordinates();

            try
            {
                var concert = (List<Concert>)await request.get_object_list(list, "concerts");

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
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Concert error");
                await msgdlg.ShowAsync();
            }
        }

        async Task<Address> geocode(Address addr)
        {
            HttpClient client = new HttpClient();
            Exception exception = null;

            string rawaddr = addr.numberStreet.ToString() + " " + addr.street + " " + addr.zipcode;
            string address = rawaddr.Replace(" ", "+");
            string url = "http://maps.google.com/maps/api/geocode/json?address=" + address;

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
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Concert geocode error");
                await msgdlg.ShowAsync();
            }
            return addr;
        }
    }
}
