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
            load_album();
        }

        async void load_album()
        {
            Exception exception = null;
            var request = new Http_get();
            albumlist = new ObservableCollection<Album>();
            List<Album> list = new List<Album>();

            try
            {
                var albums = (List<Album>)await request.get_object_list(list, "albums");

                foreach (var item in albums)
                    albumlist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }


            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Album Error");
                await msgdlg.ShowAsync();
            }
        }
    }
}
