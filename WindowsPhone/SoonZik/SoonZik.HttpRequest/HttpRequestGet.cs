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
                var listNews = JsonConvert.DeserializeObject(stringJson, myObject.GetType());
                return listNews;
            }
            catch (Exception ex)
            {
                var we = ex.InnerException as WebException;
                if (we != null)
                {
                    var resp = we.Response as HttpWebResponse;
                    var code = resp.StatusCode;
                    new MessageDialog("RespCallback Exception raised! Message:{0}" + we.Message).ShowAsync();
                    Debug.WriteLine("Status:{0}", we.Status);
                }
                else
                    throw;
            }
            return null;
        }

        public async Task<object> GetObject(object myObject, string element, string id)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/" + element + "/" + id);
            request.Method = HttpMethods.Get;
            request.Accept = "application/json;odata=verbose";
            try
            {
                var response = (HttpWebResponse)await request.GetResponseAsync();
                Stream streamResponse = response.GetResponseStream();
                string data;
                using (var reader = new StreamReader(streamResponse))
                    data = reader.ReadToEnd();
                var stringJson = JObject.Parse(data).SelectToken("content").ToString();
                var news = JsonConvert.DeserializeObject(stringJson, myObject.GetType());
                return news;
            }
            catch (Exception ex)
            {
                var we = ex.InnerException as WebException;
                if (we != null)
                {
                    var resp = we.Response as HttpWebResponse;
                    var code = resp.StatusCode;
                    new MessageDialog("RespCallback Exception raised! Message:{0}" + we.Message).ShowAsync();
                    Debug.WriteLine("Status:{0}", we.Status);
                }
                else
                    throw;
            }
            return null;
        }

        public async Task<object> GetArtist(object myObject, string element, string id)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/" + element + "/" + id + "/" + "isartist");
            request.Method = HttpMethods.Get;
            request.Accept = "application/json;odata=verbose";
            try
            {
                var response = (HttpWebResponse)await request.GetResponseAsync();
                Stream streamResponse = response.GetResponseStream();
                string data;
                using (var reader = new StreamReader(streamResponse))
                    data = reader.ReadToEnd();
                var stringJson = JObject.Parse(data).SelectToken("content").ToString();
                var news = JsonConvert.DeserializeObject(stringJson, myObject.GetType());
                return news;
            }
            catch (Exception ex)
            {
                var we = ex.InnerException as WebException;
                if (we != null)
                {
                    var resp = we.Response as HttpWebResponse;
                    var code = resp.StatusCode;
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