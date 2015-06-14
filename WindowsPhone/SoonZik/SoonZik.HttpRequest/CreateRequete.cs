using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace SoonZik.HttpRequest
{
    public class CreateRequete
    {
        #region Attribute

        public string element;
        public string id;

        public object MyObject { get; set; }

        public Uri Uri { get; set; }

        #endregion

        #region ctor

        public CreateRequete(string obj, string id)
        {
            element = obj;
            this.id = id;
            Uri =  new Uri("http://soonzikapi.herokuapp.com/" + obj + "/" + id);
        }
        #endregion

        #region Method

        public async Task<object> DoRequest()
        {
            var request = (HttpWebRequest)HttpWebRequest.Create(Uri);
            request.BeginGetResponse(Callback, request);

            return MyObject;
        }

        private async void Callback(IAsyncResult ar)
        {
            var request = ar.AsyncState as HttpWebRequest;
            if (request == null) return;
            try
            {
                var response = request.EndGetResponse(ar);
                using (var stream = new StreamReader(response.GetResponseStream()))
                {
                    var resu = await stream.ReadToEndAsync();
                    
                    var stringJson = JObject.Parse(resu).SelectToken("content").ToString();
                    var type = GetTypeOfObject();
                    
                    if (id != "")
                    {
                        MyObject = JsonConvert.DeserializeObject(stringJson, type);
                    }
                    else
                    {
                        Type listType = typeof(List<>).MakeGenericType(type);
                        MyObject = JsonConvert.DeserializeObject(stringJson, listType);
                    }

                }
            }
            catch (Exception exception)
            {
                return;
                //new MessageDialog(exception.ToString());
            }
        }

        public Type GetTypeOfObject()
        {
            if (element == "albums")
                return Type.GetType("SoonZik.HttpRequest.Poco.Album");
            if (element == "users")
                return Type.GetType("SoonZik.HttpRequest.Poco.User");
            if (element == "news")
                return Type.GetType("SoonZik.HttpRequest.Poco.News");
            if (element == "packs")
                return Type.GetType("SoonZik.HttpRequest.Poco.Pack");
            if (element == "battles")
                return Type.GetType("SoonZik.HttpRequest.Poco.Battle");
            if (element == "musiques")
                return Type.GetType("SoonZik.HttpRequest.Poco.Music");
            if (element == "address")
                return Type.GetType("SoonZik.HttpRequest.Poco.Address");
            if (element == "genres")
                return Type.GetType("SoonZik.HttpRequest.Poco.Genre");
            if (element == "infuence")
                return Type.GetType("SoonZik.HttpRequest.Poco.Influence");
            else
                return null;
        }

        #endregion
    }

}