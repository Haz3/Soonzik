using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.Tools
{
    public class Http_get
    {
        static string url = "http://api.lvh.me:3000/";
        //string url = "http://soonzikapi.herokuapp.com/";

        public static async Task<SoonZik.Models.User> get_user_by_username(string username)
        {
            var user = (SoonZik.Models.User)await get_object(new SoonZik.Models.User(), "users/find?attribute[username]=" + username);
            return user;
        }

        public static async Task<object> get_object(object Object, string elem)
        {
            Exception exception = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + elem);
            request.Method = "GET";
            request.ContentType = "application/json; charset=utf-8";

            try
            {
                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                var reader = new StreamReader(response.GetResponseStream());
                var json = JObject.Parse(reader.ReadToEnd()).SelectToken("content").ToString();

                // Substring json to remove [ and ]
                var deserialized = JsonConvert.DeserializeObject(json.Substring(1, json.Length - 2), Object.GetType());
                return deserialized;
            }
            catch (WebException ex)
            {
                exception = ex;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Get Object Error").ShowAsync();
            return null;
        }

        public async Task<object> get_object_list(object Object, string elem)
        {
            Exception exception = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url + elem);
            request.Method = "GET";
            request.ContentType = "application/json; charset=utf-8";

            try
            {
                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                var reader = new StreamReader(response.GetResponseStream());
                var json = JObject.Parse(reader.ReadToEnd()).SelectToken("content").ToString();
                var deserialized = JsonConvert.DeserializeObject(json, Object.GetType());
                return deserialized;
            }
            catch (WebException ex)
            {
                exception = ex;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Get Object List Error").ShowAsync();
            return null;
        }
    }
}
