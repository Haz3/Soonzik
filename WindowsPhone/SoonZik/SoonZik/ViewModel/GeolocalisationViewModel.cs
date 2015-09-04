using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.Devices.Geolocation;
using Windows.Foundation;
using Windows.UI.Core;
using Windows.UI.Xaml.Controls.Maps;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;

namespace SoonZik.ViewModel
{
    public class GeolocalisationViewModel : ViewModelBase
    {
        #region Ctor

        public GeolocalisationViewModel()
        {
            var task = Task.Run(async () => await InitVariable());
            task.Wait();

            ListMapIcons = new List<MapIcon>();

            GetConcert();
            GetListeners();

            CreateListElement();
        }

        #endregion

        #region Method

        private void CreateListElement()
        {
            var mapIcon = new MapIcon
            {
                Location =
                    new Geopoint(new BasicGeoposition
                    {
                        Latitude = UserLocation.Latitude,
                        Longitude = UserLocation.Longitude
                    }),
                NormalizedAnchorPoint = new Point(0.5, 1.0),
                Title = "Moi"
            };

            ListMapIcons.Add(mapIcon);
            MapElements = new ObservableCollection<MapElement>();
            foreach (var icon in ListMapIcons)
            {
                MapElements.Add(icon);
            }
            //MapElements.Add(mapIcon);
        }

        private void GetListeners()
        {
            var reqGet = new HttpRequestGet();
            ListListeners = new ObservableCollection<Listenings>();
            var listListeners = reqGet.GetListObject(new List<Listenings>(), "listenings");
            listListeners.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Listenings>;
                if (res != null)
                {
                    foreach (var item in res)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { ListListeners.Add(item); });
                    }
                }
            });
        }

        private void GetConcert()
        {
            var reqGet = new HttpRequestGet();
            ListConcerts = new ObservableCollection<Concerts>();
            var listConcerts = reqGet.GetListObject(new List<Concerts>(), "concerts");
            listConcerts.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<Concerts>;
                if (test != null)
                {
                    foreach (var item in test)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () => { ListConcerts.Add(item); });
                    }
                }
            });
        }

        private async Task InitVariable()
        {
            _myGeolocator = new Geolocator();
            var myGeoposition = await _myGeolocator.GetGeopositionAsync();
            UserLocation = myGeoposition.Coordinate;

            TwoChecked = new RelayCommand(TwoCheckedExecute);
            FiveChecked = new RelayCommand(FiveCheckedExecute);
            TenChecked = new RelayCommand(TenCheckedExecute);
            TwentyChecked = new RelayCommand(TwentyCheckedExecute);
            UserTappedCommand = new RelayCommand(UserTappedExecute);
        }

        #region Command

        private void UserTappedExecute()
        {
        }

        private void TwentyCheckedExecute()
        {
            TwoKmActivated = false;
            FiveKmActivated = false;
            TenKmActivated = false;
        }

        private void TenCheckedExecute()
        {
            TwoKmActivated = false;
            FiveKmActivated = false;
            TwentyKmActivated = false;
        }

        private void FiveCheckedExecute()
        {
            TwoKmActivated = false;
            TenKmActivated = false;
            TwentyKmActivated = false;
        }

        private void TwoCheckedExecute()
        {
            if (ListListeners != null)
            {
                foreach (var listener in ListListeners)
                {
                    var t = new MapIcon
                    {
                        Location = new Geopoint(new BasicGeoposition
                        {
                            Latitude = listener.latitude,
                            Longitude = listener.longitude
                        }),
                        NormalizedAnchorPoint = new Point(0.5, 1.0)
                    };
                    MapElements.Add(t);
                }
            }
            FiveKmActivated = false;
            TenKmActivated = false;
            TwentyKmActivated = false;
        }

        #endregion

        #endregion

        #region Attrivute

        public List<MapIcon> ListMapIcons { get; set; }

        private ObservableCollection<MapElement> _mapElements;

        public ObservableCollection<MapElement> MapElements
        {
            get { return _mapElements; }
            set
            {
                _mapElements = value;
                RaisePropertyChanged("MapElements");
            }
        }

        private ObservableCollection<Concerts> _listConcerts;

        public ObservableCollection<Concerts> ListConcerts
        {
            get { return _listConcerts; }
            set
            {
                _listConcerts = value;
                RaisePropertyChanged("ListConcerts");
            }
        }

        private ObservableCollection<Listenings> _listListeners;

        public ObservableCollection<Listenings> ListListeners
        {
            get { return _listListeners; }
            set
            {
                _listListeners = value;
                RaisePropertyChanged("ListListeners");
            }
        }

        private List<User> _listUser;

        public List<User> ListUser
        {
            get { return _listUser; }
            set
            {
                _listUser = value;
                RaisePropertyChanged("ListUser");
            }
        }

        public User UserSelected { get; set; }

        public RelayCommand TwoChecked { get; private set; }
        public RelayCommand FiveChecked { get; private set; }
        public RelayCommand TenChecked { get; private set; }
        public RelayCommand TwentyChecked { get; private set; }
        public RelayCommand UserTappedCommand { get; private set; }
        public RelayCommand GetMap { get; private set; }

        private Geolocator _myGeolocator;
        private Geocoordinate _userLocation;

        public Geocoordinate UserLocation
        {
            get { return _userLocation; }
            set
            {
                _userLocation = value;
                RaisePropertyChanged("UserLocation");
            }
        }

        private bool _twoKmActivated;

        public bool TwoKmActivated
        {
            get { return _twoKmActivated; }
            set
            {
                _twoKmActivated = value;
                RaisePropertyChanged("TwoKmActivated");
            }
        }

        private bool _fiveKmActivated;

        public bool FiveKmActivated
        {
            get { return _fiveKmActivated; }
            set
            {
                _fiveKmActivated = value;
                RaisePropertyChanged("FiveKmActivated");
            }
        }

        private bool _tenKmActivated;

        public bool TenKmActivated
        {
            get { return _tenKmActivated; }
            set
            {
                _tenKmActivated = value;
                RaisePropertyChanged("TenKmActivated");
            }
        }

        private bool _twentyKmActivated;

        public bool TwentyKmActivated
        {
            get { return _twentyKmActivated; }
            set
            {
                _twentyKmActivated = value;
                RaisePropertyChanged("TwentyKmActivated");
            }
        }

        #endregion
    }
}