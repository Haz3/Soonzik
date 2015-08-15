﻿using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;
using Windows.UI.Popups;

namespace SoonZik.Tools
{
    class Security
    {
        //public static string url = "http://api.lvh.me:3000/getKey/";
        public static string url = "http://soonzikapi.herokuapp.com/getKey/";

        public static async Task<string> getKey(string id)
        {
            Exception exception = null;
            HttpClient client = new HttpClient();

            try
            {
                var data = await client.GetStringAsync(url + id);
                var result = JObject.Parse(data);

                string key = result["key"].ToString();
                return key;
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "GetKey error").ShowAsync();
            return null;
        }

        public static async Task<string> getSecureKey(string id)
        {
            string key = await getKey(id);
            string key_to_encode = Singleton.Instance.Current_user.salt + key;
            return CryptographicBuffer.EncodeToHexString(HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha256).HashData(CryptographicBuffer.ConvertStringToBinary(key_to_encode, BinaryStringEncoding.Utf8)));
        }
    }
}
