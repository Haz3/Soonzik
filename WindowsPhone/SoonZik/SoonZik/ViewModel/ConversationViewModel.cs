using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.Networking.Sockets;
using Windows.Storage.Streams;
using Windows.UI.Core;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using WebSocketRails;

namespace SoonZik.ViewModel
{
    public class ConversationViewModel : ViewModelBase
    {
        #region Ctor

        public ConversationViewModel()
        {
            SendCommand = new RelayCommand(SendCommandExecute);
            SelectionCommand = new RelayCommand(SelectionCommandExecute);
        }

        #endregion

        #region Attribute

        private string _key { get; set; }
        public MessageWebSocket webSocket;
        public MessageWebSocket messageWebSocket;
        public DataWriter messageWriter;

        public ICommand SendCommand { get; private set; }
        public ICommand SelectionCommand { get; private set; }

        private string _cryptographic { get; set; }
        private string _conversationText;

        public string ConversationText
        {
            get { return _conversationText; }
            set
            {
                _conversationText = value;
                RaisePropertyChanged("ConversationText");
            }
        }

        private ObservableCollection<Message> _listMessages;

        public ObservableCollection<Message> ListMessages
        {
            get { return _listMessages; }
            set
            {
                _listMessages = value;
                RaisePropertyChanged("ListMessages");
            }
        }

        private User _friendUser;

        public User FriendUser
        {
            get { return _friendUser; }
            set
            {
                _friendUser = value;
                RaisePropertyChanged("FriendUser");
            }
        }

        public static User NewUser { get; set; }

        #endregion

        #region Method

        private void SelectionCommandExecute()
        {
            MyNetworkViewModel.MeaagePrompt.Hide();
            FriendUser = NewUser;
            Charge();
            ConnectSocket();
        }

        private void SendCommandExecute()
        {
            messageWriter = new DataWriter(webSocket.OutputStream);
            if (ConversationText != null)
            {
                messageWriter.WriteString(ConversationText);
                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                    () =>
                    {
                        messageWriter.StoreAsync();
                    });
            }
            //if (ConversationText == null)
            //    return;
            //var Message = new Message{dest_id = FriendUser.id, user_id = Singleton.Singleton.Instance().CurrentUser.id, msg = ConversationText};
            //var request = new HttpRequestGet();
            //var post = new HttpRequestPost();
            //try
            //{
            //    var userKey = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            //    userKey.ContinueWith(delegate(Task<object> task)
            //    {
            //        var key = task.Result as string;
            //        if (key != null)
            //        {
            //            var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(key);
            //            _cryptographic =
            //                EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
            //                                                    stringEncrypt);
            //        }
            //        var test = post.SaveMessage(Message, _cryptographic, Singleton.Singleton.Instance().CurrentUser);
            //        test.ContinueWith(delegate(Task<string> tmp)
            //        {
            //            var res = tmp.Result;
            //            if (res != null)
            //            {
            //                CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
            //                    Charge);
            //            }
            //        });
            //    });
            //}
            //catch (Exception e)
            //{

            //}
        }

        private void Charge()
        {
            ListMessages = new ObservableCollection<Message>();
            var request = new HttpRequestGet();

            ValidateKey.GetValideKey();
            var resDel = request.GetConversation(FriendUser, Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser, new List<Message>());
            resDel.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<Message>;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            foreach (var message in test)
                            {
                                if (message.dest_id == Singleton.Singleton.Instance().CurrentUser.id)
                                {
                                    message.type = "recu";
                                    ListMessages.Add(message);
                                }
                                else
                                {
                                    message.type = "envoye";
                                    ListMessages.Add(message);
                                }
                            }
                        });
                }
            });
        }

        private async void ConnectSocket()
        {

            var request = new HttpRequestGet();

            ValidateKey.GetValideKey();

            var init = new InitConnection
            {
                sercureKey = Singleton.Singleton.Instance().SecureKey,
                user_id = Singleton.Singleton.Instance().CurrentUser.id
            };

            var dispatcher = new WebSocketRailsDispatcher(new Uri("ws://soonzikapi.herokuapp.com/websocket"));

            var json = JsonConvert.SerializeObject(init);

            //trigger
            dispatcher.Trigger("init_connection", init);
            dispatcher.Trigger("who_is_online", init);


            //Bind
            dispatcher.Bind("onlineFriends", OnlineFriend);
            dispatcher.Bind("newMsg", MessageReceived);

            #region Test Avant

            /*try
            {
                webSocket = new MessageWebSocket();

                var serveur = new Uri("ws://soonzikapi.herokuapp.com/websocket", UriKind.RelativeOrAbsolute);

                webSocket.Control.MessageType = SocketMessageType.Utf8;
                // Set up callbacks

                webSocket.MessageReceived += MessageReceived;
                webSocket.Closed += Closed;
                await webSocket.ConnectAsync(serveur);
                messageWebSocket = webSocket;
            }
            catch (Exception e)
            {
                var status = WebSocketError.GetStatus(e.GetBaseException().HResult);
            }*/

            #endregion
        }

        private void MessageReceived(object sender, WebSocketRailsDataEventArgs e)
        {
            int i = 0;
        }

        private void OnlineFriend(object sender, WebSocketRailsDataEventArgs e)
        {
            int i = 0;
            #region toas

            //var toastType = ToastTemplateType.ToastText02;

            //var toastXml = ToastNotificationManager.GetTemplateContent(toastType);

            //var toastTextElement = toastXml.GetElementsByTagName("text");
            //toastTextElement[0].AppendChild(toastXml.CreateTextNode("New Message"));
            //toastTextElement[1].AppendChild(toastXml.CreateTextNode(read));

            //var toastNode = toastXml.SelectSingleNode("/toast");
            //((XmlElement) toastNode).SetAttribute("duration", "long");

            //var toast = new ToastNotification(toastXml);
            //ToastNotificationManager.CreateToastNotifier().Show(toast);

            #endregion
        }

        private void Closed(IWebSocket sender, WebSocketClosedEventArgs args)
        {
            // You can add code to log or display the code and reason
            // for the closure (stored in args.Code and args.Reason)

            // This is invoked on another thread so use Interlocked 
            // to avoid races with the Start/Close/Reset methods.
        }
        #endregion
    }
}