using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.Data.Xml.Dom;
using Windows.Networking.Sockets;
using Windows.Storage.Streams;
using Windows.UI.Core;
using Windows.UI.Notifications;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

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
            FriendUser = NewUser;
            Charge();
            ConnectSocket();
        }

        private async void SendCommandExecute()
        {
            messageWriter = new DataWriter(webSocket.OutputStream);
            messageWriter.WriteString(ConversationText);
            await messageWriter.StoreAsync();
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
            var userKey = request.GetUserKey(Singleton.Singleton.Instance().CurrentUser.id.ToString());
            userKey.ContinueWith(delegate(Task<object> task)
            {
                var _key = task.Result as string;
                if (_key != null)
                {
                    var stringEncrypt = KeyHelpers.GetUserKeyFromResponse(_key);
                    _cryptographic =
                        EncriptSha256.EncriptStringToSha256(Singleton.Singleton.Instance().CurrentUser.salt +
                                                            stringEncrypt);
                    var resDel = request.GetConversation(FriendUser, _cryptographic,
                        Singleton.Singleton.Instance().CurrentUser, new List<Message>());
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
            });
        }

        private async void ConnectSocket()
        {
            try
            {
                webSocket = new MessageWebSocket();

                var serveur = new Uri("ws://echo.websocket.org", UriKind.RelativeOrAbsolute);

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
            }
        }

        private void Closed(IWebSocket sender, WebSocketClosedEventArgs args)
        {
            // You can add code to log or display the code and reason
            // for the closure (stored in args.Code and args.Reason)

            // This is invoked on another thread so use Interlocked 
            // to avoid races with the Start/Close/Reset methods.
            var webSocket = Interlocked.Exchange(ref messageWebSocket, null);
            if (webSocket != null)
            {
                webSocket.Dispose();
            }
        }

        private void MessageReceived(MessageWebSocket sender, MessageWebSocketMessageReceivedEventArgs args)
        {
            try
            {
                using (var reader = args.GetDataReader())
                {
                    reader.UnicodeEncoding = UnicodeEncoding.Utf8;
                    var read = reader.ReadString(reader.UnconsumedBufferLength);


                    var toastType = ToastTemplateType.ToastText02;

                    var toastXml = ToastNotificationManager.GetTemplateContent(toastType);

                    var toastTextElement = toastXml.GetElementsByTagName("text");
                    toastTextElement[0].AppendChild(toastXml.CreateTextNode("Hello C# Corner"));
                    toastTextElement[1].AppendChild(toastXml.CreateTextNode("I am poping you from a Winmdows Phone App"));

                    var toastNode = toastXml.SelectSingleNode("/toast");
                    ((XmlElement) toastNode).SetAttribute("duration", "long");

                    var toast = new ToastNotification(toastXml);
                    ToastNotificationManager.CreateToastNotifier().Show(toast);
                }
            }
            catch (Exception ex) // For debugging
            {
                var status = WebSocketError.GetStatus(ex.GetBaseException().HResult);
                // Add your specific error-handling code here.
            }
        }

        #endregion
    }
}