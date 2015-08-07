using Newtonsoft.Json.Linq;
using System;
using System.Net;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;
using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;

namespace SoonZik.Tools
{
    class Post_comment
    {
        // Comment_txt = content, type = music | album | news, id = id of the news | album | music ...
        public Post_comment(string comment_txt, string type, string id)
        {
            send_comment(comment_txt, type, id);
        }

        public async void send_comment(string comment_txt, string type, string id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = Singleton.Instance.Current_user.salt + await getKey(Singleton.Instance.Current_user.id);
                string encode = CryptographicBuffer.EncodeToHexString(HashAlgorithmProvider.OpenAlgorithm(HashAlgorithmNames.Sha256).HashData(CryptographicBuffer.ConvertStringToBinary(secureKey, BinaryStringEncoding.Utf8)));

                string url = type + "/addcomment/" + id;
                string comment_data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&content=" + WebUtility.UrlEncode(comment_txt) +
                    "&secureKey=" + encode;


                // HTTP_POST -> URL + DATA
                var response = await request.post_request(type + "/addcomment/" + id, comment_data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    await new MessageDialog("Comment SEND").ShowAsync();
                }
                else
                    await new MessageDialog("Comment KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }


            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Comment POST Error");
                await msgdlg.ShowAsync();
            }
        }

        public async Task<string> getKey(int id)
        {
            Exception exception = null;
            HttpClient client = new HttpClient();
            
            try
            {
                var data = await client.GetStringAsync("http://api.lvh.me:3000/getKey/" + id.ToString());
                var result = JObject.Parse(data);

                //var lat = result["results"][0]["geometry"]["location"]["lat"];
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
    }
}
