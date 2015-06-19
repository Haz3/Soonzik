using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Threading.Tasks;
using Windows.UI.Popups;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using SoonZik.HttpRequest.HttpExtensions;

namespace SoonZik.HttpRequest
{
    public class HttpRequestGet
    {
        public async Task<object> GetListObject(object myObject, string element)
        {
            HttpWebRequest request = (HttpWebRequest) WebRequest.Create("http://soonzikapi.herokuapp.com/" + element);
            return await DoRequest(myObject, request);
        }

        public async Task<object> GetObject(object myObject, string element, string id)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/" + element + "/" + id);
            return await DoRequest(myObject, request);
        }

        public async Task<object> GetArtist(object myObject, string element, string id)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/" + element + "/" + id + "/" + "isartist");
            return await DoRequest(myObject, request);
        }

        public async Task<object> Search(object myObject, string element)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/" + "search?query=" + element);
            return await DoRequest(myObject, request);
        }

        public async Task<object> GetUserKey(object myObject, string id)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/" + "getKey" + id);
            return await DoRequest(myObject, request);
        }

        private static async Task<object> DoRequest(object myObject, HttpWebRequest request)
        {
            request.Method = HttpMethods.Get;
            request.Accept = "application/json;odata=verbose";
            try
            {
                var response = (HttpWebResponse) await request.GetResponseAsync();
                Stream streamResponse = response.GetResponseStream();
                string data;
                using (var reader = new StreamReader(streamResponse))
                data = reader.ReadToEnd();
                var stringJson = JObject.Parse(data).SelectToken("content").ToString();
                var obj = JsonConvert.DeserializeObject(stringJson, myObject.GetType());
                return obj;
            }
            catch (Exception ex)
            {
                var we = ex.InnerException as WebException;
                if (we != null)
                {
                    new MessageDialog("RespCallback Exception raised! Message:{0}" + we.Message).ShowAsync();
                    Debug.WriteLine("Status:{0}", we.Status);
                }
                else
                    throw;
            }
            return null;
        }
    }
}