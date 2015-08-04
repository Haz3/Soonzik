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
    class PackViewModel
    {
        public ObservableCollection<Pack> packlist { get; set; }

        public PackViewModel()
        {
            load_pack();
        }

        async void load_pack()
        {
            Exception exception = null;
            var request = new Http_get();
            packlist = new ObservableCollection<Pack>();
            List<Pack> list = new List<Pack>();

            try
            {
                var packs = (List<Pack>)await request.get_object_list(list, "packs");

                foreach (var item in packs)
                    packlist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Pack error");
                await msgdlg.ShowAsync();
            }
        }
    }
}
