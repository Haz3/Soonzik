using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace SoonZik.HttpRequest
{
    public class HttpRequestPost
    {
        public String Received { get; set; }

        public async Task<String> ConnexionSimple(string username, string password)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://soonzikapi.herokuapp.com/login");
            var postData = "email=" + username + "&password=" + password;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> GetHttpPostResponse(HttpWebRequest request, string postData)
        {
            Received = null;
            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";

            byte[] requestBody = Encoding.UTF8.GetBytes(postData);

            // ASYNC: using awaitable wrapper to get request stream
            using (var postStream = await request.GetRequestStreamAsync())
            {
                // Write to the request stream.
                // ASYNC: writing to the POST stream can be slow
                await postStream.WriteAsync(requestBody, 0, requestBody.Length);
            }

            try
            {
                // ASYNC: using awaitable wrapper to get response
                var response = (HttpWebResponse)await request.GetResponseAsync();
                if (response != null)
                {
                    var reader = new StreamReader(response.GetResponseStream());
                    // ASYNC: using StreamReader's async method to read to end, in case
                    // the stream i slarge.
                    Received = await reader.ReadToEndAsync();
                }
            }
            catch (WebException we)
            {
                var reader = new StreamReader(we.Response.GetResponseStream());
                string responseString = reader.ReadToEnd();
                Debug.WriteLine(responseString);
                return responseString;
            }
            return Received;
        }
    }
}
