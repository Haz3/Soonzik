using Newtonsoft.Json.Linq;
using SoonZik.Models;
using SoonZik.Tools;
using SoonZik.ViewModels.Command;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;


namespace SoonZik.ViewModels
{
    class BattleViewModel
    {
        public ObservableCollection<Battle> battlelist { get; set; }
        public Battle selected_battle { get; set; }

        public ICommand do_vote_one
        {
            get;
            private set;
        }

        public ICommand do_vote_two
        {
            get;
            private set;
        }

        public BattleViewModel()
        {
            load_battle();
            do_vote_one = new BattleCommand(this);
            do_vote_two = new BattleCommand(this);
        }

        async void load_battle()
        {
            Exception exception = null;
            battlelist = new ObservableCollection<Battle>();

            try
            {
                var battles = (List<Battle>)await Http_get.get_object(new List<Battle>(), "battles");
                foreach (var item in battles)
                    battlelist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Battle error").ShowAsync();
        }

        public async void vote(string id)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string post_data =
                    "user_id=" + Singleton.Instance.Current_user.id.ToString() +
                    "&artist_id=" + id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                var response = await request.post_request("battles/" + selected_battle.id.ToString() + "/vote", post_data);
                var json = JObject.Parse(response).SelectToken("code");

                // Debug. 200 = success
                if (json.ToString() == "200" || json.ToString() == "201")
                    await new MessageDialog("Vote OK").ShowAsync();
                else
                    await new MessageDialog("Vote KO").ShowAsync();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Vote Error").ShowAsync();
        }
    }
}
