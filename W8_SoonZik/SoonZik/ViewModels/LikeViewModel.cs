using Newtonsoft.Json.Linq;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class LikeViewModel
    {
        public static async Task<bool> like(string type, string id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string url = type + "/like/" + id;
                string data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey;


                // HTTP_POST -> URL + DATA
                var response = await request.post_request(type + "/.../" + id, data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    await new MessageDialog("Like OK").ShowAsync();
                    return true;
                }
                else
                    await new MessageDialog("Like KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Like POST Error").ShowAsync();
            return false;
        }

        public static async Task<bool> unlike(string type, string id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string url = type + "/unlike/" + id;
                string data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey;


                // HTTP_POST -> URL + DATA
                var response = await request.post_request(type + "/.../" + id, data);
                var json = JObject.Parse(response).SelectToken("message");

                if (json.ToString() == "Created")
                {
                    await new MessageDialog("unlike OK").ShowAsync();
                    return true;
                }
                else
                    await new MessageDialog("unlike KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "unlike POST Error").ShowAsync();
            return false;
        }
    }
}
