using Newtonsoft.Json.Linq;
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
        static async Task<string> getKey(string id)
        {
            Exception exception = null;
            HttpClient client = new HttpClient();

            try
            {
                var data = await client.GetStringAsync("http://api.lvh.me:3000/getKey/" + id);
                var result = JObject.Parse(data);

                string key = result["key"].ToString();
                return key;
            }
            catch (Exception e)
            {
                exception = e;
            }
            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "GetKey error");
                await msgdlg.ShowAsync();
            }
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
