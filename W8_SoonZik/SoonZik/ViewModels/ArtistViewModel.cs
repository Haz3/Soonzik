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
            artistlist = new ObservableCollection<User>();

            try
            {
                var albums = (List<User>)await Http_get.get_object(new List<User>(), "users");

                foreach (var item in albums)
                    artistlist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Artist Error").ShowAsync();
        }
    }
}
