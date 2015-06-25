﻿using System;
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
        private const string ApiUrl = "http://soonzikapi.herokuapp.com/";

        public async Task<object> GetListObject(object myObject, string element)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + element);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetObject(object myObject, string element, string id)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + element + "/" + id);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetArtist(object myObject, string element, string id)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + element + "/" + id + "/" + "isartist");
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> Search(object myObject, string element)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "search?query=" + element);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetUserKey(object myObject, string id)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "getKey" + id);
            return await DoRequestForObject(myObject, request);
        }

        public async Task<object> GetSocialToken(string id, string socialNetwork)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "getSocialToken/" + id + "/" + socialNetwork);
            return await DoRequest(request);
        }

        private static async Task<string> DoRequest(HttpWebRequest request)
        {
            request.Method = HttpMethods.Get;
            request.Accept = "application/json;odata=verbose";
            try
            {
                var response = (HttpWebResponse)await request.GetResponseAsync();
                Stream streamResponse = response.GetResponseStream();
                string data;
                using (var reader = new StreamReader(streamResponse))
                    data = reader.ReadToEnd();
                return data;
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


        private static async Task<object> DoRequestForObject(object myObject, HttpWebRequest request)
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