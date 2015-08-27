using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.Data.Xml.Dom;
using Windows.UI.Notifications;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class AlbumViewModel
    {
        public ObservableCollection<Album> albumlist { get; set; }

        public AlbumViewModel()
        {
            load_albums();
        }

        //public AlbumViewModel(int id)
        //{
        //    load_albums(id);
        //}

        //async void load_albums(int id)
        //{
        //      SOON
        //}

        async void load_albums()
        {
            Exception exception = null;
            albumlist = new ObservableCollection<Album>();

            try
            {
                var albums = (List<Album>)await Http_get.get_object(new List<Album>(), "albums");
                foreach (var item in albums)
                    albumlist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Album Error").ShowAsync();
        }
    }
}
