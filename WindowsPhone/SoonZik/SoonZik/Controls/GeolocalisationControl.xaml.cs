using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.Devices.Geolocation;
using Windows.Foundation;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Controls.Maps;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Annotations;
using SoonZik.HttpRequest.Poco;

// Pour en savoir plus sur le modèle d'élément Contrôle utilisateur, consultez la page http://go.microsoft.com/fwlink/?LinkId=234236

namespace SoonZik.Controls
{
    public sealed partial class GeolocalisationControl : UserControl, INotifyPropertyChanged
    {
        public GeolocalisationControl()
        {
            this.InitializeComponent();
            DataContext = this;

            var task = Task.Run(async () => await InitVariable());
            task.Wait();

            CreateListElement();
        }

         #region Method

        private void CreateListElement()
        {
            MapIcon mapIcon = new MapIcon();

            mapIcon.Location = new Geopoint(new BasicGeoposition() { Latitude = UserLocation.Latitude, Longitude = UserLocation.Longitude });
            mapIcon.NormalizedAnchorPoint = new Point(0.5, 1.0);
            mapIcon.Title = "Moi";

            MapElements = new ObservableCollection<MapElement>();
            MapElements.Add(mapIcon);

            MyMapControl.MapElements.Add(mapIcon);
            MyMapControl.Center = UserLocation.Point;
            MyMapControl.ZoomLevel = 15;
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
            FiveKmActivated = false;
            TenKmActivated = false;
            TwentyKmActivated = false;

        }
        #endregion

        #endregion

        #region Attrivute

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

        private List<User> _listUser;

        public List<User> ListUser
        {
            get { return _listUser;}
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

        public event PropertyChangedEventHandler PropertyChanged;

        [NotifyPropertyChangedInvocator]
        private void RaisePropertyChanged([CallerMemberName] string propertyName = null)
        {
            var handler = PropertyChanged;
            if (handler != null) handler(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}
