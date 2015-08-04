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
    class MusicViewModel
    {
            public ObservableCollection<Music> musiclist { get; set; }

            public MusicViewModel()
            {
                load_music();
            }

            async void load_music()
            {
                Exception exception = null;
                var request = new Http_get();
                musiclist = new ObservableCollection<Music>();
                List<Music> list = new List<Music>();

                try
                {
                    var musics = (List<Music>)await request.get_object_list(list, "musics");

                    foreach (var item in musics)
                        musiclist.Add(item);
                }
                catch (Exception e)
                {
                    exception = e;
                }

                if (exception != null)
                {
	                MessageDialog msgdlg = new MessageDialog(exception.Message,"Music error");
	                await msgdlg.ShowAsync();
                }
            }
    }
}
