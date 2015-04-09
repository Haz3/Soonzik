using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;
using System.Net;
using Windows.UI.Popups;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.HttpRequest
{
    public class HttpReq
    {
        #region Attribute

        public Uri uri; //= new Uri("http://soonzikapi.herokuapp.com/albums");
        #endregion

        #region Ctor

        public HttpReq()
        {
            var test = new CreateRequete("albums", "");
            
            var request = (HttpWebRequest)HttpWebRequest.Create(test.Uri);
            request.BeginGetResponse(Callback, request);
        }

        private void Callback(IAsyncResult ar)
        {
            var request = ar.AsyncState as HttpWebRequest;
            if (request == null) return;
            try
            {
                var response = request.EndGetResponse(ar);
                using (var stream = new StreamReader(response.GetResponseStream()))
                {
                    string resu = stream.ReadToEnd();

                    var ListObject = JObject.Parse(resu).SelectToken("content").ToString();
                    var ListAlbums = JsonConvert.DeserializeObject<List<Album>>(ListObject);
                }

            }
            catch (Exception exception)
            {
                return;
                //new MessageDialog(exception.ToString());
            }
        }

        #endregion

        #region Method
        
        #endregion
    }
}
