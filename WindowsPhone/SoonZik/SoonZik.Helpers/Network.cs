using System;
using Windows.Networking.Connectivity;

namespace SoonZik.Helpers
{
    public class InternetConnectionChangedEventArgs : EventArgs
    {
        public InternetConnectionChangedEventArgs(bool isConnected)
        {
            this._isConnected = isConnected;
        }

        private bool _isConnected;
        public bool IsConnected
        {
            get { return _isConnected; }
        }
    }

    public static class Network
    {
        public static event EventHandler<InternetConnectionChangedEventArgs>
            InternetConnectionChanged;

        static Network()
        {
            NetworkInformation.NetworkStatusChanged += (s) =>
            {
                if (InternetConnectionChanged != null)
                {
                    var arg = new InternetConnectionChangedEventArgs(IsConnected);
                    InternetConnectionChanged(null, arg);
                }
            };
        }

        public static bool IsConnected
        {
            get
            {
                var profile = NetworkInformation.GetInternetConnectionProfile();
                var isConnected = (profile != null
                    && profile.GetNetworkConnectivityLevel() ==
                    NetworkConnectivityLevel.InternetAccess);
                return isConnected;
            }
        }
    }

}