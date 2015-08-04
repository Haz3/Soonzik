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
        public async Task<object> get_object_list(object Object, string elem)
        {
            Exception exception = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://api.lvh.me:3000/" + elem);
            //HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/" + elem);
            request.Method = "GET";
            request.ContentType = "application/json; charset=utf-8";

            try
            {
                HttpWebResponse response = (HttpWebResponse)await request.GetResponseAsync();
                var reader = new StreamReader(response.GetResponseStream());
               // var test = JObject.Parse(reader.ReadToEnd()).ToString();

                var json = JObject.Parse(reader.ReadToEnd()).SelectToken("content").ToString();
                var deserialized = JsonConvert.DeserializeObject(json, Object.GetType());
                return deserialized;
            }
            catch (WebException ex)
            {
                exception = ex;
            }
            
            
            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message,"Get Error");
                await msgdlg.ShowAsync();
            }
            return null;
        }
    }
}
