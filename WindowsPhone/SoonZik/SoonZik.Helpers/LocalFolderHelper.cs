using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Threading.Tasks;
using Windows.Data.Json;
using Windows.Storage;
using Newtonsoft.Json;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.Helpers
{
    public class LocalFolderHelper
    {
        #region Attribute

        static Windows.Storage.StorageFolder localFolder = Windows.Storage.ApplicationData.Current.LocalFolder;
        public static Music test { get; set; }
        #endregion

        #region Ctor
        #endregion

        #region Method

        public static async void Delete()
        {
            await localFolder.DeleteAsync();
        }

        public static async void WriteTimestamp()
        {
            StorageFile sampleFile = await localFolder.CreateFileAsync("Musiques.txt", CreationCollisionOption.ReplaceExisting);
            foreach (var music in Singleton.Singleton.Instance().SelectedMusicSingleton)
            {
                var json = JsonConvert.SerializeObject(music);
                await FileIO.WriteTextAsync(sampleFile, json);
            }
        }

        public static async Task<object> ReadTimestamp()
        {
            try
            {
                StorageFile sampleFile = await localFolder.GetFileAsync("Musiques.txt");
                String timestamp = await FileIO.ReadTextAsync(sampleFile);
                test = (Music) JsonConvert.DeserializeObject(timestamp, new Music().GetType());
                return test;
                // Data is contained in timestamp
            }
            catch (Exception)
            {
              
                // Timestamp not found
            }
            return null;
        }

        #endregion
    }
}
