using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml.Media.Imaging;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.HttpRequest
{
    public class HttpRequestPost
    {
        #region Attribute

        public String Received { get; set; }
        private const string ApiUrl = "http://soonzikapi.herokuapp.com/";
        #endregion

        #region Method
        public async Task<String> ConnexionSimple(string username, string password)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "login");
            var postData = "email=" + username + "&password=" + password;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> ConnexionSocial(string socialType, string encryptKey, string token, string uid)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "social-login");
            var postData = "uid=" + uid + "&provider=" + socialType + "&encrypted_key=" + encryptKey + "&token=" + token;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> Save(User myUser, string sha256, string password)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "users/save");
            var postData =
                "&user[email]=" + myUser.email +
                "&user[password]=" + password +
                "&user[username]=" + myUser.username +
                "&user[birthday]=" + myUser.birthday +
                "&user[language]=" + "fr" +
                "&user[fname]=" + myUser.fname +
                "&user[lname]=" + myUser.lname +
                //"&user[description]=" + myUser.description +
                "&user[phoneNumber]=" + myUser.phoneNumber;
                
            if (myUser.address != null)
            {
                postData += "&address[numberStreet]=" + myUser.address.NumberStreet +
                "&address[complement]=" + myUser.address.Complement +
                "&address[street]=" + myUser.address.Street +
                "&address[city]=" + myUser.address.City +
                "&address[country]=" + myUser.address.Country +
                "&address[zipcode]=" + myUser.address.Zipcode;
            }
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> Update(User myUser, string sha256)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "users/update/");
            var postData = "user[email]=" + myUser.email + "&user[username]=" + myUser.username + "&user[birthday]=" + myUser.birthday
                + "&user[language]=" + myUser.language + "&user[fname]=" + myUser.fname + "&user[lname]=" + myUser.lname + "&user[description]=" + myUser.description
                + "&user[phoneNumber]=" + myUser.phoneNumber + "&address[numberStreet]=" + myUser.address.NumberStreet + "&address[complement]=" + myUser.address.Complement
                + "&address[street]=" + myUser.address.Street
                + "&address[city]=" + myUser.address.City + "&address[country]=" + myUser.address.Country + "&address[zipcode]=" + myUser.address.Zipcode
                + "&secureKey=" + sha256 + "&user_id=" + myUser.id;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> Unfollow(string sha256, string unfollowId, string userId)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "users/unfollow");
            var postData = "follow_id=" + unfollowId + "&secureKey=" + sha256 + "&user_id=" + userId;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> Follow(string sha256, string followId, string userId)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "users/follow");
            var postData = "follow_id=" + followId + "&secureKey=" + sha256 + "&user_id=" + userId;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> AddFriend(string sha256, string friendId, string userId)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "users/addfriend");
            var postData = "friend_id=" + friendId + "&secureKey=" + sha256 + "&user_id=" + userId;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> DelFriend(string sha256, string friendId, string userId)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "users/delfriend");
            var postData = "friend_id=" + friendId + "&secureKey=" + sha256 + "&user_id=" + userId;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> Vote(string sha256, string battleId, string artistId, string userId)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "/battles/" + battleId + "/vote");
            var postData = "artist_id=" + artistId + "&secureKey=" + sha256 + "&user_id=" + userId;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> UploadImage(BitmapImage image, string sha256, string userId, string contentType, string name)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "users/upload");
            var postData = "file[content_type]=" + contentType + "&file[original_filename]" + name + "&file[tempfile]" + image + "&secureKey=" + sha256 + "&user_id=" + userId;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> SendTweet(string message, User myUser, string sha256)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "tweets/save");
            var postData = "tweet[user_id]=" + myUser.id + "&tweet[msg]=" + message + "&secureKey=" + sha256 +
                           "&user_id=" + myUser.id;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> SendComment(string message, Album myAlbum, string sha256, User myUser)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "albums/addcomment/" + myAlbum.id);
            var postData = "content=" + message + "&secureKey=" + sha256 + "&user_id=" + myUser.id;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> UpdatePlaylist(Playlist thePlaylist, Music theMusic, string sha256, User myUser)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "/musics/addtoplaylist/");

            var postData = "id=" + theMusic.id + "&playlist_id=" + thePlaylist.id + "&secureKey=" + sha256 + "&user_id=" + myUser.id;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> SaveCart(Music theMusic, Album theAlbum, string sha256, User myUser)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "/carts/save");

            var postData = "";
            if (theMusic != null)
                postData = "cart[user_id]=" + myUser.id + "&cart[typeObj]=" + "Music" + "&cart[obj_id]=" + theMusic.id + "&secureKey=" + sha256 + "&user_id=" + myUser.id;
            else if (theAlbum != null)
                postData = "cart[user_id]=" + myUser.id + "&cart[typeObj]=" + "Album" + "&cart[obj_id]=" + theAlbum.id + "&secureKey=" + sha256 + "&user_id=" + myUser.id;
            return await GetHttpPostResponse(request, postData);
        }

        public async Task<String> SavePlaylist(Playlist thePlaylist, string sha256, User myUser)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(ApiUrl + "/playlists/save");

            var postData = "playlist[user_id]=" + myUser.id + "&playlist[name]=" + thePlaylist.name + "&secureKey=" + sha256 + "&user_id=" + myUser.id;
            return await GetHttpPostResponse(request, postData);
        }
        #endregion

        #region DoPost

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
        #endregion

    }
}
