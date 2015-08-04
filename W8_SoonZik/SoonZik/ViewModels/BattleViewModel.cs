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
    class BattleViewModel
    {
        public ObservableCollection<Battle> battlelist { get; set; }

        public BattleViewModel()
        {
            load_battle();
        }

        async void load_battle()
        {
            Exception exception = null;
            var request = new Http_get();
            battlelist = new ObservableCollection<Battle>();
            List<Battle> list = new List<Battle>();

            try
            {
                var battles = (List<Battle>)await request.get_object_list(list, "battles");

                foreach (var item in battles)
                    battlelist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
            {
                MessageDialog msgdlg = new MessageDialog(exception.Message, "Battle error");
                await msgdlg.ShowAsync();
            }

        }
    }
}
