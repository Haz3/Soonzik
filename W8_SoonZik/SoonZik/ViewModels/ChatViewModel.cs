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
    class ChatViewModel
    {
        public ObservableCollection<Message> messages_list { get; set; }

        public ChatViewModel(int id)
        {
            load_messages(id);
        }

        async void load_messages(int id)
        {
            Exception exception = null;
            messages_list = new ObservableCollection<Message>();


            // /messages/conversation/2?user_id=1&secureKey=2479e4eb4e23f7a2d807ac01a6858d584a17d10a14d9cffb1ef055a66f804e0d
            try
            {
                var messages = (List<Message>)await Http_get.get_object(new List<Message>(), "messages/conversation/" + id.ToString() + "?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));

                foreach (var item in messages)
                {
                    messages_list.Add(item);
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
