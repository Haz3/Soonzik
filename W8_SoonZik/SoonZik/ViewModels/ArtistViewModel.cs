using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class ArtistViewModel
    {
         public ObservableCollection<User> artistlist { get; set; }

        public ArtistViewModel()
        {
            load_artist();
        }

        async void load_artist()
        {
            Exception exception = null;
            var request = new Http_get();
            artistlist = new ObservableCollection<User>();
            List<User> list = new List<User>();

            try
            {
                var albums = (List<User>)await request.get_object_list(list, "users");

                foreach (var item in albums)
                    artistlist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }


            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Artist Error");
                await msgdlg.ShowAsync();
            }
        }
    }
}
