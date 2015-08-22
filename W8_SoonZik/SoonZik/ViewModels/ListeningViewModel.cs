using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SoonZik.Models;
using SoonZik.Tools;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class ListeningViewModel
    {
        public ObservableCollection<Listening> listening_list { get; set; }

        public ListeningViewModel()
        {
            load_listening();
        }

        async void load_listening()
        {
            Exception exception = null;
            var request = new Http_get();
            listening_list = new ObservableCollection<Listening>();
            List<Listening> list = new List<Listening>();

            try
            {
                var listenings = (List<Listening>)await request.get_object_list(list, "listenings");

                foreach (var item in listenings)
                {
                    listening_list.Add(item);
                }

            }
            catch (Exception e)
            {
                exception = e;
            }


            if (exception != null)
                await new MessageDialog(exception.Message, "Listening Error").ShowAsync();
        }
    }
}
